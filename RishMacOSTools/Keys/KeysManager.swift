//
//  KeysManager.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.05.2024.
//

import Foundation
import AppKit

enum KeysManager {
    static var keys: [String: KeyObject]?
    static func getKeys(force: Bool = false) -> [KeyObject] {
        var keysArray: [KeyObject] = []
        if keys == nil || force {
            keysArray.removeAll()
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: StaticHelper.sshFolderUrl.path)
                for file in files {
                    if file == ".DS_Store" {
                        continue
                    }
                    let filePath = StaticHelper.sshFolderUrl.appendingPathComponent(file)
                    do {
                        let content = try String(contentsOf: filePath)
                        if content.contains("-----BEGIN ") {
                            let key = KeyObject(fileName: filePath.lastPathComponent)
                            if key.keyExist {
                                keysArray.append(key)
                            }
                        }
                    } catch {
                        print("Error reading file: \(file), error: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error reading SSH directory: \(error.localizedDescription)")
            }
        }
        
        return keysArray
    }
    
    static func generateKey(name: String, comment: String = "", message: Bool = true) -> Bool {
        let keyPath = StaticHelper.sshFolderUrl.appendingPathComponent(name).path
        let pubPath = keyPath + ".pub"
        
        if FileManager.default.fileExists(atPath: keyPath) || FileManager.default.fileExists(atPath: pubPath) {
            StaticHelper.showAlert(message: String(localized: "key.exist"), error: true)
            return false
        }
        
        let process = Process()
        process.launchPath = "/usr/bin/ssh-keygen"
        process.arguments = ["-t", "ed25519", "-C", comment, "-f", keyPath, "-N", ""]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        process.launch()
        process.waitUntilExit()
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if let errorMessage = String(data: errorData, encoding: .utf8), !errorMessage.isEmpty {
            StaticHelper.showAlert(message: String(localized: "key.generate_error \(errorMessage)"), error: true)
            return false
        }
        
        if message {
            StaticHelper.showAlert(message: String(localized: "key.generate_success"))
        }
        return true
    }
    
    static func createPubKey(name: String, message: Bool = true, quiet: Bool = false) -> Bool {
        let keyPath = "\(StaticHelper.sshFolderUrl.path)/\(name)"
        let pubPath = "\(keyPath).pub"
        
        guard FileManager.default.fileExists(atPath: keyPath) else {
            StaticHelper.showAlert(message: String(localized: "key.not_exist"), error: true)
            return false
        }
        
        guard !FileManager.default.fileExists(atPath: pubPath) else {
            StaticHelper.showAlert(message: String(localized: "key.public.exist"), error: true)
            return false
        }
        
        let process = Process()
        process.launchPath = "/usr/bin/ssh-keygen"
        process.arguments = ["-y", "-f", keyPath]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        process.launch()
        process.waitUntilExit()
        
        let publicKeyData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        guard let publicKey = String(data: publicKeyData, encoding: .utf8) else {
            StaticHelper.showAlert(message: String(localized: "key.public.get_error"), error: true)
            return false
        }
        
        guard process.terminationStatus == 0 else {
            let errorMessage = String(data: errorData, encoding: .utf8) ?? String(localized: "error_unknown")
            if !quiet {
                StaticHelper.showAlert(message: String(localized: "key.generate_error \(errorMessage)"), error: true)
                
            }
            return false
        }
        
        do {
            try publicKey.write(toFile: pubPath, atomically: true, encoding: .utf8)
            if message {
                StaticHelper.showAlert(message: String(localized: "key.public.save_success"))
            }
            return true
        } catch {
            StaticHelper.showAlert(message: String(localized: "key.public.generate_error \(error.localizedDescription)"),error: true)
            return false
        }
    }
    
    static func editPublicKeyComment(keyName: String, newComment: String) -> Bool {
        let pubKeyPath = "\(StaticHelper.sshFolderUrl.path)/\(keyName).pub"
        
        guard FileManager.default.fileExists(atPath: pubKeyPath) else {
            StaticHelper.showAlert(message: String(localized: "key.public.not_exist"), error: true)
            return false
        }
        
        do {
            var pubKeyContent = try String(contentsOfFile: pubKeyPath)
            let components = pubKeyContent.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: false)
            
            guard components.count >= 2 else {
                StaticHelper.showAlert(message: String(localized: "key.public.comment_not_found"), error: true)
                return false
            }
            
            let keyType = components[0]
            let keyValue = components[1]
            let trimmedComment = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
            
            pubKeyContent = "\(keyType) \(keyValue) \(trimmedComment)"
            
            try pubKeyContent.write(toFile: pubKeyPath, atomically: true, encoding: .utf8)
            
            let attributes = [FileAttributeKey.posixPermissions: 0o644]
            try FileManager.default.setAttributes(attributes, ofItemAtPath: pubKeyPath)
            
            StaticHelper.showAlert(message: String(localized: "key.public.comment_edit_success"))
            return true
        } catch {
            StaticHelper.showAlert(message: String(localized: "key.public.edit_error \(error.localizedDescription)"), error: true)
            return false
        }
    }
    
    static func removeKey(name: String) -> Bool {
        let fileManager = FileManager.default
        let sshFolderPath = StaticHelper.sshFolderUrl.path
        let keyPath = "\(sshFolderPath)/\(name)"
        let pubPath = "\(keyPath).pub"
        
        if !fileManager.fileExists(atPath: keyPath) && !fileManager.fileExists(atPath: pubPath) {
            StaticHelper.showAlert(message: String(localized: "key.not_exist"),error: true)
            return false
        }
        
        do {
            if fileManager.fileExists(atPath: keyPath) {
                _ = removeKeyFromAgent(name: name,message: false,quiet: true)
                try fileManager.trashItem(at: URL(fileURLWithPath: keyPath), resultingItemURL: nil)
            }
            if fileManager.fileExists(atPath: pubPath) {
                try fileManager.trashItem(at: URL(fileURLWithPath: pubPath), resultingItemURL: nil)
            }
            StaticHelper.showAlert(message: String(localized: "key.delete_success"))
            
            return true
        } catch {
            StaticHelper.showAlert(message: String(localized: "key.delete_error \(error.localizedDescription)"),error: true)
            return false
        }
    }
    
    static func insertKey(name: String, secret: String) -> Bool {
        let fileManager = FileManager.default
        let sshFolderPath = StaticHelper.sshFolderUrl.path
        let keyPath = "\(sshFolderPath)/\(name)"
        let pubPath = "\(keyPath).pub"
        
        if fileManager.fileExists(atPath: keyPath) || fileManager.fileExists(atPath: pubPath) {
            StaticHelper.showAlert(message: String(localized: "key.exist"), error: true)
            return false
        }
        
        if secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            StaticHelper.showAlert(message: String(localized: "key.private.error_empty"), error: true)
            return false
        }
        
        if !secret.contains("-----BEGIN") {
            StaticHelper.showAlert(message: String(localized: "key.private.error_format"), error: true)
            return false
        }
        
        do {
            try secret.write(toFile: keyPath, atomically: true, encoding: .utf8)
            try fileManager.setAttributes([.posixPermissions: 0o600], ofItemAtPath: keyPath)
            
            let create = createPubKey(name: name,message: false,quiet: true)
            if !create{
                StaticHelper.showAlert(message: String(localized: "key.public.save_error"), error: true)
                return false
            }
            StaticHelper.showAlert(message: String(localized: "key.private.save_success"))
            
            return true
        } catch {
            StaticHelper.showAlert(message: String(localized: "key.private.save_error \(error.localizedDescription)"), error: true)
            return false
        }
        
    }
    
    static func removeKeyFromAgent(name: String? = nil, message: Bool = true, quiet: Bool = false) -> Bool {
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ssh-add")
        if let name = name {
            let keyPath = StaticHelper.sshFolderUrl.appendingPathComponent(name).path
            process.arguments = ["-d", keyPath]
        } else {
            process.arguments = ["-D"]
        }
        
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        process.standardInput = nil
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let outputMessage = String(data: outputData, encoding: .utf8) ?? ""
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let errorMessage = String(data: errorData, encoding: .utf8) ?? ""
            
            if process.terminationStatus == 0 {
                if message {
                    if name != nil {
                        StaticHelper.showAlert(message: String(localized: "agent.remove_key_success"), error: false)
                    } else {
                        StaticHelper.showAlert(message: String(localized: "agent.remove_keys_success"), error: false)
                    }
                }
                return true
            } else {
                if !quiet {
                    let messageToDisplay = errorMessage.isEmpty ? outputMessage : errorMessage
                    StaticHelper.showAlert(message: String(localized: "agent.remove_key_error \(messageToDisplay)"), error: true)
                }
                return false
            }
        } catch {
            if !quiet {
                StaticHelper.showAlert(message: "Error starting process: \(error.localizedDescription)", error: true)
            }
            return false
        }
    }
}
