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


}
