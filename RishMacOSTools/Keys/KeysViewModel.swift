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
    
    var list: [KeyObject] {
        if searchText.isEmpty || searchText.count < 2 {
            return sshKeys
        } else {
            return sshKeys.filter {
                $0.keyName.lowercased().contains(searchText.lowercased()) ||
                $0.keyComment.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init() {
        loadKeys()
    }
    
    func loadKeys(force: Bool = false) {
        sshKeys = KeysManager.getKeys(force: force)
            .sorted { $0.keyName.lowercased() < $1.keyName.lowercased() }
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
}
