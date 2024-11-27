//
//  KeyObject.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.05.2024.
//

import Foundation

struct KeyObject: Identifiable {
    let id = UUID()
    var keyName: String = ""
    var keyComment: String = ""
    var path: String = ""
    var publicKey: String = ""
    var publicKeyPath: String = ""
    var serverCommand: String = ""
    var keyExist: Bool = false
    
    init(fileName: String? = nil) {
        path = ""
        guard let fileName = fileName else { return }
        
        keyName = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        path = "\(StaticHelper.sshFolderUrl.path)/\(keyName)"
        guard FileManager.default.fileExists(atPath: path) else { return }
        keyExist = true
        
        publicKeyPath = "\(StaticHelper.sshFolderUrl.path)/\(keyName).pub"
        if FileManager.default.fileExists(atPath: publicKeyPath) {
            do {
                let content = try String(contentsOfFile: publicKeyPath)
                publicKey = content
                extractComment(fromPublicKey: content)
            } catch {
                print("Error reading public key file: \(error)")
            }
        } else {
            publicKey = ""
            publicKeyPath = ""
        }
        
        if publicKey != "" {
            serverCommand = "echo '\(publicKey)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
        } else {
            serverCommand = ""
        }
    }
    
    private mutating func extractComment(fromPublicKey content: String) {
        let components = content.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
        if components.count > 2 {
            self.keyComment = String(components[2])
        }
    }
}
