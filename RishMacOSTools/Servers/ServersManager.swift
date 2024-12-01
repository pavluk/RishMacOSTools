//
//  ServersManager.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 13.05.2024.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

enum ServersManager {
    static var servers: [ServerObject] = []
    
    static var configPath: String {
        return StaticHelper.sshFolderUrl.appendingPathComponent("config").path
    }
    
    static var configBacPath: String {
        return StaticHelper.sshFolderUrl.appendingPathComponent("config.rmtbac").path
    }
    
    
    static func getServers(force: Bool = false) -> [ServerObject] {
        if servers.isEmpty || force {
            if FileManager.default.fileExists(atPath: StaticHelper.sshFolderUrl.path),
               FileManager.default.fileExists(atPath: configPath) {
                servers.removeAll()
                do {
                    let lines = try String(contentsOfFile: configPath).components(separatedBy: .newlines)
                    
                    for line in lines {
                        if line.lowercased().hasPrefix("host ") {
                            let server = ServerObject(host: line.trimmingCharacters(in: .whitespaces))
                            if !server.host.isEmpty {
                                servers.append(server)
                            }
                        }
                    }
                } catch {
                    StaticHelper.showAlert(
                        message: "Error reading config file: \(error.localizedDescription)",
                        error: true
                    )
                }
            }
        }
        
        return servers
    }
    
    static func createServer(host: String, hostname: String, user: String, key: String,addKeysToAgent: Bool = true) -> Bool {
        let servers = getServers()
        if servers.contains(where: { $0.host.lowercased() == host.lowercased() }) {
            StaticHelper.showAlert(
                message: String(localized: "server.exist.host"),
                error: true
            )
            return false
        }
        
        var server = ServerObject(host: host)
        server.host = host
        server.hostname = hostname
        server.user = user
        server.key = KeyObject(fileName: key)
        server.keyName = server.key.keyName
        server.publicKey = server.key.publicKey
        server.additions["Compression"] = "yes"
        if addKeysToAgent{
            server.additions["AddKeysToAgent"] = "yes"
        }
        setServer(server)
        
        if pullServersToFile() {
            StaticHelper.showAlert(
                message: String(localized: "server.append.success")
            )
            return true
        } else {
            return false
        }
    }
    
    static func editServer(server: inout ServerObject) -> Bool {
        let _ = getServers()
        if let index = servers.firstIndex(where: { $0.host.lowercased() == server.host.lowercased() }) {
            server.key = KeyObject(fileName: server.keyName)
            server.keyName = server.key.keyName
            server.publicKey = server.key.publicKey
            
            servers[index] = server;
            if pullServersToFile() {
                StaticHelper.showAlert(
                    message: String(localized: "server.edit.success")
                )
                return true
            } else {
                return false
            }
        }
        else{
            StaticHelper.showAlert(
                message: String(localized: "server.not_exist"),
                error: true
            )
            return false
        }
        
    }
    
    static func removeServer(host: String) -> Bool {
        let _ = getServers(force: true)
        guard !servers.isEmpty else {
            StaticHelper.showAlert(
                message: String(localized: "server.remove.success"),
                error: true
            )
            return true
        }
        
        let server = ServerObject(host: host)
        if server.host.isEmpty {
            StaticHelper.showAlert(
                message: String(localized: "server.not_exist"),
                error: true
            )
            return false
        }
        
        if !servers.contains(where: { $0.host.lowercased() == host.lowercased() }) {
            StaticHelper.showAlert(
                message: String(localized: "server.not_exist"),
                error: true
            )
            return false
        }
        
        if let index = servers.firstIndex(where: { $0.host == server.host }) {
            servers.remove(at: index)
        }
        if pullServersToFile() {
            StaticHelper.showAlert(message: String(localized: "server.remove.success"))
            return true
        } else {
            _ = removeKnownHosts(message: false, quiet: true)
            return false
        }
    }
    
    static func setServer(_ server: ServerObject) {
        servers.append(server)
    }
    
    static func pullServersToFile() -> Bool {
        var backup = false
        do {
            if servers.isEmpty {
                let _ = getServers()
            }
            
            var result: [String] = []
            if !servers.isEmpty {
                let sortedServers = servers.sorted(by: { $0.host < $1.host })
                for server in sortedServers {
                    result.append(server.toConfigFileString())
                }
            }
            
            
            
            let content = result.joined(separator: "\n")
            
            if !FileManager.default.fileExists(atPath: configPath) {
                FileManager.default.createFile(atPath: configPath, contents: nil)
            }
            
            if FileManager.default.fileExists(atPath: configBacPath) {
                try FileManager.default.removeItem(atPath: configBacPath)
            }
            
            try FileManager.default.copyItem(atPath: configPath, toPath: configBacPath)
            backup = true
            
            try content.write(toFile: configPath, atomically: true, encoding: .utf8)
            
            return true
        } catch {
            var backupRestore = 0
            if backup {
                do {
                    try FileManager.default.copyItem(atPath: configBacPath, toPath: configPath)
                    backupRestore = 1
                } catch {
                    backupRestore = -1
                }
            }
            
            var message = String(localized: "config.error.append \(error.localizedDescription)")
            if backupRestore != 0 {
                message += "\n"
                message += (backupRestore == 1) ? String(localized: "backup.success") : String(localized: "backup.error")
            }
            StaticHelper.showAlert(message: message, error: true)
            
            return false
        }
    }
    
    static func connectToServer(host: String, user: String? = nil) {
        var sshCommand = "ssh \(host)"
        if let user = user, !user.isEmpty {
            sshCommand = "ssh \(user)@\(host)"
        }
        
        let appleScriptCommand = """
        osascript -e 'tell application "Terminal"
            do script "\(sshCommand)"
            activate
        end tell'
        """
        do {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["bash", "-c", appleScriptCommand]
            try process.run()
        } catch {
            StaticHelper.showAlert(message: String(localized: "server.error.ssh \(error.localizedDescription)"),error: true)
        }
    }
    
    
    static func removeKnownHosts(message: Bool = true, quiet: Bool = false) -> Bool {
        let fileName = StaticHelper.sshFolderUrl.appendingPathComponent("known_hosts").path
        guard FileManager.default.fileExists(atPath: fileName) else { return true }
        
        do {
            try FileManager.default.removeItem(atPath: fileName)
            if message {
                StaticHelper.showAlert(message: String(localized: "success.delete.known_hosts"))
            }
            return true
        } catch {
            if !quiet {
                StaticHelper.showAlert(message: String(localized: "error.delete.known_hosts \(error.localizedDescription)"),error: true)
            }
            return false
        }
    }
    static func exportProfiles(profiles: [ServerObject]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let profileData: AnyEncodable = profiles.count == 1 ? AnyEncodable(ITermProfileObject(server: profiles[0])) : AnyEncodable(["Profiles": profiles.filter { $0.host != "*" }.map { ITermProfileObject(server: $0) }])
        
        do {
            let jsonData = try encoder.encode(profileData)
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [UTType.json]
            savePanel.nameFieldStringValue = profiles.count == 1 ? "\(profiles[0].host.capitalized).json" : "profiles.json"
            savePanel.begin { response in
                if response == .OK, let url = savePanel.url {
                    do {
                        try jsonData.write(to: url)
                        StaticHelper.showAlert(message: url.path)
                    } catch {
                        StaticHelper.showAlert(message: "Error export profiles: \(error)", error: true)
                    }
                }
            }
        } catch {
            StaticHelper.showAlert(message: "Error export profiles get data: \(error)", error: true)
        }
    }
    static func isITermInstalled() -> Bool {
        let fileManager = FileManager.default
        let potentialPaths = [
            "/Applications/iTerm.app",
            "\(NSHomeDirectory())/Applications/iTerm.app"
        ]
        
        for path in potentialPaths {
            if fileManager.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
}
