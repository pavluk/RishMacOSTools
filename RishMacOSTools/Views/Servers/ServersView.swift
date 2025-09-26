//
//  ServersView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 10.05.2024.
//

import SwiftUI

struct ServersView: View {
    @StateObject private var serverViewModel = ServersViewModel()
    @State private var isCreatedPresented = false
    @State private var isEditPresented = false
    @State private var showDeleteConfirmation = false
    @State private var hoveredId: UUID?

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(String(localized: "button.server_create")) {
                        isCreatedPresented = true
                    }
                    Button {
                        serverViewModel.loadServers(force: true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Spacer()

                    Button(String(localized: "button.delete.known_hosts")) {
                        _ = ServersManager.removeKnownHosts()
                    }
                    Button(String(localized: "button.open_folder_ssh")) {
                        NSWorkspace.shared.open(StaticHelper.sshFolderUrl)
                    }
                }
                .padding(8)

                List {
                    ForEach(Array(serverViewModel.list.filter { $0.host != "*" }.enumerated()), id: \.element.id) { index, server in
                        ZStack {
                            HStack {
                                // Row number
                                Text("\(index + 1)")
                                    .frame(width: 30, alignment: .leading)
                                    .fontWeight(.bold)

                                // Host
                                Button {
                                    if serverViewModel.isConnectingHost == nil {
                                        serverViewModel.connectToServer(host: server.host)
                                    }
                                } label: {
                                    Text(server.host)
                                        .fontWeight(.bold)
                                        .frame(width: 160, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.bordered)
                                .help(String(localized: "button.server_connect"))

                                // Hostname
                                Text(server.hostname)
                                    .frame(width: 160, alignment: .leading)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        StaticHelper.copyToClipboard(
                                            text: server.hostname,
                                            name: String(localized: "label.server_hostname")
                                        )
                                    }
                                    .help(String(localized: "label.server_hostname"))

                                // User
                                Text(server.user)
                                    .frame(width: 100, alignment: .leading)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        StaticHelper.copyToClipboard(
                                            text: server.user,
                                            name: String(localized: "label.server_user")
                                        )
                                    }
                                    .help(String(localized: "label.server_user"))

                                // Key name + copy buttons (icons on the left)
                                HStack(spacing: 8) {
                                    Button {
                                        StaticHelper.copyToClipboard(
                                            text: server.key.serverCommand,
                                            name: String(localized: "label.server_command")
                                        )
                                    } label: {
                                        Image(systemName: "apple.terminal.on.rectangle")
                                    }
                                    .buttonStyle(.bordered)
                                    .help(String(localized: "label.server_command"))

                                    Button {
                                        StaticHelper.copyToClipboard(
                                            text: server.key.publicKey,
                                            name: String(localized: "label.key_public")
                                        )
                                    } label: {
                                        Image(systemName: "key")
                                    }
                                    .buttonStyle(.bordered)
                                    .help(String(localized: "label.key_public"))

                                    Text(server.keyName)
                                        .fontWeight(.medium)
                                        .frame(width: 100, alignment: .leading)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            StaticHelper.copyToClipboard(
                                                text: server.key.publicKey,
                                                name: String(localized: "label.key_public")
                                            )
                                        }
                                        .help(String(localized: "label.key_name"))
                                }

                                Spacer()

                                // Actions
                                HStack(spacing: 12) {
                                    Button {
                                        serverViewModel.selectedServer = server
                                        isEditPresented = true
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .buttonStyle(.bordered)
                                    .help(String(localized: "button.server_edit"))

                                    Button {
                                        serverViewModel.selectedServer = server
                                        showDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.bordered)
                                    .help(String(localized: "button.delete_server"))
                                }
                            }
                            .padding(.vertical, 4)
                            .background(
                                hoveredId == server.id
                                ? Color.gray.opacity(0.15)
                                : Color.clear
                            )
                            .onHover { hovering in
                                hoveredId = hovering ? server.id : nil
                            }
                            .contextMenu {
                                ServerContextMenu(server: server) {
                                    serverViewModel.selectedServer = server
                                    isEditPresented = true
                                } onDelete: {
                                    serverViewModel.selectedServer = server
                                    showDeleteConfirmation = true
                                }
                            }

                            // Overlay when connecting
                            if serverViewModel.isConnectingHost == server.host {
                                Color.black.opacity(0.25)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .searchable(text: $serverViewModel.searchText)
                .navigationTitle("RishMacOSTools")
            }
            .sheet(isPresented: $isCreatedPresented) {
                ServerCreateView {
                    serverViewModel.loadServers(force: true)
                }
            }
            .sheet(isPresented: $isEditPresented) {
                if let server = serverViewModel.selectedServer {
                    ServerEditView(server: server) {
                        serverViewModel.loadServers(force: true)
                    }
                }
            }
            .sheet(isPresented: $showDeleteConfirmation) {
                if let server = serverViewModel.selectedServer {
                    ServerDeleteView(server: server) {
                        serverViewModel.loadServers(force: true)
                    }
                }
            }
        }
    }
}
