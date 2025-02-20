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
    var body: some View{
        NavigationStack {
            VStack {
                HStack {
                    Button(String(localized: "button.server_create"), action: {
                        isCreatedPresented = true
                    })
                    if ServersManager.isITermInstalled() && !serverViewModel.servers.isEmpty{
                        Button(action: {
                            ServersManager.exportProfiles(profiles: serverViewModel.servers);
                        }) {
                            Text("button.server_export_all.iterm")
                        }
                    }
                    Button(action: {
                        serverViewModel.loadServers(force: true)
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                    Button(String(localized: "button.delete.known_hosts"), action: {
                        _ = ServersManager.removeKnownHosts()
                    })
                    Button(String(localized: "button.open_folder_ssh"), action: {
                        NSWorkspace.shared.open(StaticHelper.sshFolderUrl)
                    })
                }
                .padding(8)
                Table(serverViewModel.list.filter { $0.host != "*" },
                      sortOrder: $serverViewModel.sortOrder) {
                    TableColumn("label.server_host", value: \.host) { server in
                        Text(server.host)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .contentShape(Rectangle())
                            .contextMenu{
                                ServerContextMenu(server: server) {
                                    serverViewModel.selectedServer = server
                                    isEditPresented = true
                                } onDelete: {
                                    serverViewModel.selectedServer = server
                                    showDeleteConfirmation = true
                                }
                            }
                    }
                    TableColumn("label.server_hostname", value: \.hostname) { server in
                        Text(server.hostname)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .contentShape(Rectangle())
                            .contextMenu{
                                ServerContextMenu(server: server) {
                                    serverViewModel.selectedServer = server
                                    isEditPresented = true
                                } onDelete: {
                                    serverViewModel.selectedServer = server
                                    showDeleteConfirmation = true
                                }
                            }
                    }
                    TableColumn("label.server_user", value: \.user) { server in
                        Text(server.user)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .contentShape(Rectangle())
                            .contextMenu{
                                ServerContextMenu(server: server) {
                                    serverViewModel.selectedServer = server
                                    isEditPresented = true
                                } onDelete: {
                                    serverViewModel.selectedServer = server
                                    showDeleteConfirmation = true
                                }
                            }
                    }
                    TableColumn("label.key_name", value: \.keyName) { server in
                        Text(server.keyName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .contentShape(Rectangle())
                            .contextMenu{
                                ServerContextMenu(server: server) {
                                    serverViewModel.selectedServer = server
                                    isEditPresented = true
                                } onDelete: {
                                    serverViewModel.selectedServer = server
                                    showDeleteConfirmation = true
                                }
                            }
                    }
                }
                      .searchable(text: $serverViewModel.searchText)
                      .onChange(of: serverViewModel.sortOrder) { _, sortOrder in
                          serverViewModel.servers.sort(using: sortOrder)
                      }
                      .navigationTitle("RishMacOSTools")
            }
            .sheet(isPresented: $isCreatedPresented) {
                ServerCreateView {
                    serverViewModel.loadServers(force: true)
                }
            }
            .sheet(isPresented: $isEditPresented) {
                if let server = serverViewModel.selectedServer {
                    ServerEditView(server: server, onEdit: {
                        serverViewModel.loadServers(force: true)
                    })
                }
            }
            .sheet(isPresented: $showDeleteConfirmation) {
                if let server = serverViewModel.selectedServer {
                    ServerDeleteView(server: server, onDelete: {
                        serverViewModel.loadServers(force: true)
                    })
                }
            }
        }
        
    }
}

#Preview {
    ServersView()
}
