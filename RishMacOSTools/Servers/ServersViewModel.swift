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
    
    func removeServer(host: String) {
        let _ = ServersManager.removeServer(host: host)
        loadServers(force: true)
    }
}
