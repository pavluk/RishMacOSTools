//
//  KeysView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 28.07.2024.
//
import SwiftUI

struct KeysView: View {
    @EnvironmentObject var keysViewModel: KeysViewModel
    @State private var isInsertionPresented = false
    @State private var isCreatedPresented = false
    @State private var isEditCommentPresented = false
    @State private var showDeleteConfirmation = false
    @State private var hoveredId: UUID?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(String(localized: "button.create_key")) {
                        isCreatedPresented = true
                    }
                    Button(String(localized: "button.insert_key")) {
                        isInsertionPresented = true
                    }
                    Toggle(String(localized: "keys.filter.unused_only"), isOn: $keysViewModel.showUnusedOnly)
                        .toggleStyle(.switch)
                        .help(String(localized: "keys.filter.unused_only"))
                    Button {
                        keysViewModel.loadKeys(force: true)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
                    Button(String(localized: "button.open_folder_ssh")) {
                        NSWorkspace.shared.open(StaticHelper.sshFolderUrl)
                    }
                    Button(String(localized: "button.remove_keys_from_agent")) {
                        _ = KeysManager.removeKeyFromAgent()
                    }
                }
                .padding(8)
                
                List {
                    ForEach(keysViewModel.list) { sshKey in
                        let isUnused = !keysViewModel.isKeyUsed(sshKey)
                        let unusedAccent = Color.orange.opacity(0.72)
                        ZStack {
                            HStack {
                                // Key name
                                HStack(spacing: 8) {
                                    Text(sshKey.keyName)
                                        .fontWeight(.bold)
                                        .foregroundColor(isUnused ? unusedAccent : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.middle)
                                        .frame(width: 230, alignment: .leading)
                                        .contentShape(Rectangle())
                                        .frame(
                                            height: StaticHelper.rowHeight
                                        )
                                        .onTapGesture {
                                            keysViewModel.selectedSSHKey = sshKey
                                            StaticHelper.copyToClipboard(
                                                text: sshKey.keyName,
                                                name: String(localized: "label.key_name")
                                            )
                                        }
                                        .help(String(localized: "label.key_name"))

                                    Text(isUnused ? String(localized: "keys.unused.badge") : "")
                                        .font(.caption)
                                        .foregroundColor(unusedAccent)
                                        .lineLimit(1)
                                        .frame(width: 120, alignment: .leading)
                                        .help(isUnused ? String(localized: "keys.unused.badge") : "")
                                }
                                
                                // Public key + copy buttons
                                HStack(spacing: 8) {
                                    if sshKey.publicKey.isEmpty{
                                        Button("button.create_public_key", action: {
                                            keysViewModel.createPublicKey(name: sshKey.keyName)
                                        }).buttonStyle(.bordered)
                                    }
                                    else{
                                        Button {
                                            StaticHelper.copyToClipboard(
                                                text: sshKey.publicKey,
                                                name: String(localized: "label.key_public")
                                            )
                                        } label: {
                                            Image(systemName: "doc.on.doc")
                                        }
                                        .buttonStyle(.bordered)
                                        .help(String(localized: "label.key_public"))
                                        
                                        Button {
                                            StaticHelper.copyToClipboard(
                                                text: sshKey.serverCommand,
                                                name: String(localized: "label.server_command")
                                            )
                                        } label: {
                                            Image(systemName: "apple.terminal.on.rectangle")
                                        }
                                        .buttonStyle(.bordered)
                                        .help(String(localized: "label.server_command"))
                                        Text(sshKey.publicKey)
                                            .lineLimit(1)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .frame(
                                                height: StaticHelper.rowHeight
                                            )
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                StaticHelper.copyToClipboard(
                                                    text: sshKey.publicKey,
                                                    name: String(localized: "label.key_public")
                                                )
                                            }
                                            .contextMenu{
                                                KeyContextMenu(sshKey: sshKey) {
                                                    keysViewModel.selectedSSHKey = sshKey
                                                    isEditCommentPresented = true
                                                } onDelete: {
                                                    keysViewModel.selectedSSHKey = sshKey
                                                    showDeleteConfirmation = true
                                                }
                                            }
                                    }
                                    
                                }
                                
                                // Key comment
                                Text(sshKey.keyComment)
                                    .frame(
                                        width: 120,
                                        alignment: .leading
                                    )
                                    .frame(
                                        height: StaticHelper.rowHeight
                                    )
                                    .padding(2)
                                    .truncationMode(.tail)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        keysViewModel.selectedSSHKey = sshKey
                                        isEditCommentPresented = true
                                    }
                                    .help(String(localized: "label.key_comment"))
                                
                                Spacer()
                                
                                // Actions
                                HStack(spacing: 12) {
                                    if !sshKey.publicKey.isEmpty{
                                        Button {
                                            keysViewModel.selectedSSHKey = sshKey
                                            isEditCommentPresented = true
                                        } label: {
                                            Image(systemName: "pencil")
                                        }
                                        .buttonStyle(.bordered)
                                        .help(String(localized: "button.key_edit_comment"))
                                    }
                                    Button {
                                        keysViewModel.selectedSSHKey = sshKey
                                        showDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.bordered)
                                    .help(String(localized: "button.delete_key"))
                                }
                            }
                            .padding(.vertical, 4)
                            .background(
                                hoveredId == sshKey.id
                                ? Color.gray.opacity(0.15)
                                : Color.clear
                            )
                            .onHover { hovering in
                                hoveredId = hovering ? sshKey.id : nil
                            }
                            .contextMenu {
                                KeyContextMenu(sshKey: sshKey) {
                                    keysViewModel.selectedSSHKey = sshKey
                                    isEditCommentPresented = true
                                } onDelete: {
                                    keysViewModel.selectedSSHKey = sshKey
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .searchable(text: $keysViewModel.searchText)
                .navigationTitle("RishMacOSTools")
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("title.delete_key '\(keysViewModel.selectedSSHKey?.keyName ?? "unknown")'?"),
                        primaryButton: .destructive(Text("button.delete_key")) {
                            if let sshKey = keysViewModel.selectedSSHKey {
                                keysViewModel.removeKey(name: sshKey.keyName)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .sheet(isPresented: $isEditCommentPresented) {
            if let sshKey = keysViewModel.selectedSSHKey {
                KeyCommentEditView(sshKey: sshKey) {
                    keysViewModel.loadKeys()
                }
            }
        }
        .sheet(isPresented: $isInsertionPresented) {
            KeyInsertionView(isPresented: $isInsertionPresented) { name, secret, isPresented in
                let insert = KeysManager.insertKey(name: name, secret: secret)
                if insert {
                    keysViewModel.loadKeys(force: true)
                    isPresented.wrappedValue = false
                }
            }
        }
        .sheet(isPresented: $isCreatedPresented) {
            KeyCreateView(isPresented: $isCreatedPresented) { name, comment, isPresented in
                let create = KeysManager.generateKey(name: name, comment: comment)
                if create {
                    keysViewModel.loadKeys(force: true)
                    isPresented.wrappedValue = false
                }
            }
        }
        .onAppear {
            keysViewModel.refreshUsage(forceServers: true)
        }
    }
}
