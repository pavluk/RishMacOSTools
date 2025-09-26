//
//  ServersViewModel.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 13.05.2024.
//

import Foundation

class ServersViewModel: ObservableObject {
    @Published var servers: [ServerObject] = []
    @Published var searchText: String = ""
    @Published var sortOrder: [KeyPathComparator<ServerObject>] = [KeyPathComparator(\ServerObject.host)]
    @Published var selectedServer: ServerObject?
    @Published var isConnectingHost: String? = nil
    
    var list: [ServerObject] {
        if searchText.isEmpty || searchText.count < 2 {
            return servers
        } else {
            return servers.filter {
                $0.host.lowercased().contains(searchText.lowercased()) ||
                $0.hostname.lowercased().contains(searchText.lowercased()) ||
                $0.keyName.lowercased().contains(searchText.lowercased()) ||
                $0.user.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    init() {
        loadServers()
    }
    
    func loadServers(force: Bool = false) {
        servers = ServersManager.getServers(force: force)
            .sorted { $0.host.lowercased() < $1.host.lowercased() }
    }
    
    func removeServer(host: String,deleteKey: Bool = false) {
        let _ = ServersManager.removeServer(host: host, deleteKey: deleteKey)
        loadServers(force: true)
    }
    func connectToServer(host: String) {
        isConnectingHost = host
        DispatchQueue.global().async {
            ServersManager.connectToServer(host: host)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isConnectingHost = nil
            }
        }
    }
    func indexOf(_ server: ServerObject) -> Int? {
           list.firstIndex { $0.id == server.id }
       }
}
