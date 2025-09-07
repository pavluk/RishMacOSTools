//
//  Helpers.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 02.06.2024.
//

import Foundation
import AppKit

struct StaticHelper {
    static let sshFolderUrl = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".ssh")
    static func copyToClipboard(text: String,name: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        
        showAlert(message: String(localized: "\(name) clipboard.message"))
        
    }
    
    static func showAlert(message: String,error:Bool = false) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = (error) ? .critical : .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    static func filterToLatin(_ input: String) -> String {
        return input.filter { $0.isLetter && $0.isASCII || $0.isNumber || $0 == "-" || $0 == "_" || $0 == "." }
    }
    @discardableResult
       static func ensureSSHScaffold() -> Bool {
           let fm = FileManager.default
           let folderURL = sshFolderUrl
           let configURL = folderURL.appendingPathComponent("config")
           do {
               try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
               if !fm.fileExists(atPath: configURL.path) {
                   fm.createFile(atPath: configURL.path, contents: Data())
               }
               try fm.setAttributes([.posixPermissions: NSNumber(value: Int16(0o700))], ofItemAtPath: folderURL.path)
               try fm.setAttributes([.posixPermissions: NSNumber(value: Int16(0o600))], ofItemAtPath: configURL.path)
               return true
           } catch {
               showAlert(message: "Failed to prepare ~/.ssh: \(error.localizedDescription)", error: true)
               return false
           }
       }
}
