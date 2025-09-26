//
//  ServerContextMenu.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 23.11.2024.
//

import SwiftUI

struct ServerContextMenu: View {
    var server: ServerObject
    var onEdit: () -> Void
    var onDelete: () -> Void
    @StateObject private var serverViewModel = ServersViewModel()
    var body: some View {
        VStack {
            Button(action: {
                if serverViewModel.isConnectingHost == nil {
                    serverViewModel.connectToServer(host: server.host)
                }
            }) {
                Text("button.server_connect")
                Image(systemName: "server.rack")
            }
            .disabled(serverViewModel.isConnectingHost == server.host)
            .help(String(localized: "button.server_connect"))
            Button(action: {
                onEdit();
            }) {
                Text("button.server_edit")
                Image(systemName: "pencil")
            }
            if server.key.keyExist {
                Button(action: {
                    StaticHelper.copyToClipboard(text: server.key.publicKey, name: String(localized: "label.key_public"))
                }) {
                    Text("label.key_public")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    StaticHelper.copyToClipboard(text: server.key.serverCommand, name: String(localized: "label.server_command"))
                }) {
                    VStack {
                        Text("label.server_command")
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Button(action: {
                onDelete();
            }) {
                VStack {
                    Text("button.delete_server")
                        .foregroundColor(.red)
                    Image(systemName: "trash.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
