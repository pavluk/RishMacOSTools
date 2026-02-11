//
//  KeysViewModel.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 08.05.2024.
//

import AppKit

class KeysViewModel: ObservableObject {
    @Published var sshKeys: [KeyObject] = []
    @Published var searchText: String = ""
    @Published var sortOrder = [KeyPathComparator(\KeyObject.keyName)]
    @Published var selectedSSHKey: KeyObject?
    @Published var showUnusedOnly: Bool = false
    @Published private(set) var usedKeyNames: Set<String> = []
    
    var list: [KeyObject] {
        var result = sshKeys

        if showUnusedOnly {
            result = result.filter { !isKeyUsed($0) }
        }

        if searchText.isEmpty || searchText.count < 2 {
            return result
        } else {
            return result.filter {
                $0.keyName.lowercased().contains(searchText.lowercased()) ||
                $0.keyComment.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init() {
        loadKeys()
    }
    
    func loadKeys(force: Bool = false) {
        reloadUsedKeyNames(forceServers: force)
        sshKeys = KeysManager.getKeys(force: force)
            .sorted { $0.keyName.lowercased() < $1.keyName.lowercased() }
    }

    func refreshUsage(forceServers: Bool = true) {
        reloadUsedKeyNames(forceServers: forceServers)
    }

    func isKeyUsed(_ key: KeyObject) -> Bool {
        usedKeyNames.contains(normalizeKeyName(key.keyName))
    }
    
    func getKeyById(id: UUID?) -> KeyObject? {
        return sshKeys.first { $0.id == id }
    }
    
    func removeKey(name: String,showMessage:Bool = true) {
        if KeysManager.removeKey(name: name,showMessageSuccess:showMessage) {
            loadKeys(force: true)
        }
    }
    
    func createPublicKey(name: String) {
        if KeysManager.createPubKey(name: name) {
            loadKeys(force: true)
        }
    }

    private func reloadUsedKeyNames(forceServers: Bool) {
        let servers = ServersManager.getServers(force: forceServers)
        usedKeyNames = Set(
            servers
                .map { normalizeKeyName($0.keyName) }
                .filter { !$0.isEmpty }
        )
    }

    private func normalizeKeyName(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }

        let lastPathComponent = (trimmed as NSString).lastPathComponent
        let normalized = lastPathComponent.hasSuffix(".pub")
        ? String(lastPathComponent.dropLast(4))
        : lastPathComponent

        return normalized.lowercased()
    }
}
