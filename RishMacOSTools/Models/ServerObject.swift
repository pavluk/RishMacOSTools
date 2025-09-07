//
//  ServerObject.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 10.05.2024.
//

import Foundation

struct ServerObject: Identifiable {
    var id = UUID()
    var host: String = ""
    var hostname: String = ""
    var user: String = ""
    var keyName: String = ""
    var publicKey: String = ""
    var additions: [String: String] = [:]
    var key: KeyObject = KeyObject()

    
    init(host: String? = nil) {
        guard let host = host else { return }
        self.host = host.replacingOccurrences(of: "Host", with: "").trimmingCharacters(in: .whitespaces)
        
        guard FileManager.default.fileExists(atPath: StaticHelper.sshFolderUrl.path),
              FileManager.default.fileExists(atPath: ServersManager.configPath) else {
            print("SSH folder or config path does not exist")
            return
        }
        
        do {
            let lines = try String(contentsOfFile: ServersManager.configPath).components(separatedBy: .newlines)
            var find = false
            
            for line in lines {
                if find && line.lowercased().hasPrefix("host ") {
                    break
                }
                
                if !find && line.lowercased().hasPrefix("host \(self.host)") {
                    self.host = line.replacingOccurrences(of: "Host", with: "").trimmingCharacters(in: .whitespaces)
                    find = true
                    continue
                }
                
                if !find {
                    continue
                }
                
                let clean = line.trimmingCharacters(in: .whitespaces)
                if clean.isEmpty {
                    continue
                }
                
                if clean.lowercased().hasPrefix("hostname") {
                    hostname = clean.replacingOccurrences(of: "Hostname", with: "").trimmingCharacters(in: .whitespaces)
                    continue
                }
                
                if clean.lowercased().hasPrefix("user") {
                    user = clean.replacingOccurrences(of: "User", with: "").trimmingCharacters(in: .whitespaces)
                    continue
                }
                
                if clean.lowercased().hasPrefix("identityfile") {
                    keyName = clean.replacingOccurrences(of: "IdentityFile", with: "").trimmingCharacters(in: .whitespaces)
                }
                
                if let index = clean.firstIndex(of: " ") {
                    let key = String(clean[..<index])
                    let value = String(clean[clean.index(after: index)...])
                    additions[key] = value
                } else {
                    additions[clean] = ""
                }
            }
            
            if !keyName.isEmpty {
                key = KeyObject(fileName: keyName)
                if key.keyExist {
                    keyName = key.keyName
                    publicKey = key.publicKey
                }
            }
        } catch {
            print("Error reading config file: \(error.localizedDescription)")
        }
    }
    
    func toConfigFileString() -> String {
        var result: [String] = []
        
        if !host.isEmpty {
            result.append("Host \(host)")
        }
        if !hostname.isEmpty {
            result.append("    Hostname \(hostname)")
        }
        if !user.isEmpty {
            result.append("    User \(user)")
        }
        
        for (key, value) in additions {
            if key.lowercased() != "identityfile" {
                result.append("    \(key) \(value)")
            }
        }
        
        var identityFile = additions["IdentityFile"] ?? ""
        if key.keyExist {
            identityFile = "~/.ssh/\(key.keyName)"
        }
        if !identityFile.isEmpty {
            result.append("    IdentityFile \(identityFile)")
        }
        
        return result.joined(separator: "\n")
    }
}
