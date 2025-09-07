import SwiftUI

struct KeysView: View {
    @EnvironmentObject var keysViewModel: KeysViewModel
    @State private var isInsertionPresented = false
    @State private var isCreatedPresented = false
    @State private var isEditCommentPresented = false
    @State private var showDeleteConfirmation = false
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(String(localized: "button.create_key"), action: {
                        isCreatedPresented = true
                    })
                    Button("button.insert_key",action: {
                        isInsertionPresented = true
                    })
                    Button(action: {
                        keysViewModel.loadKeys(force: true)
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                    Button(String(localized: "button.open_folder_ssh"), action: {
                        NSWorkspace.shared.open(StaticHelper.sshFolderUrl)
                    })
                    Button(String(localized: "button.remove_keys_from_agent"), action: {
                        _ = KeysManager.removeKeyFromAgent()
                    })
                }
                .padding(8)
                Table(keysViewModel.list, sortOrder: $keysViewModel.sortOrder){
                    TableColumn("label.key_name", value: \.keyName) { sshKey in
                        Text(sshKey.keyName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .contentShape(Rectangle())
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
                    TableColumn("label.key_public"){ sshKey in
                        if sshKey.publicKey.isEmpty{
                            Button("button.create_public_key", action: {
                                keysViewModel.createPublicKey(name: sshKey.keyName)
                            }).buttonStyle(.bordered)
                        }
                        else{
                            Text(sshKey.publicKey)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 44)
                                .contentShape(Rectangle())
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
                    TableColumn("label.key_comment", value: \.keyComment) { sshKey in
                        Text(sshKey.keyComment)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 44)
                            .lineLimit(nil)
                            .truncationMode(.tail)
                            .contentShape(Rectangle())
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
                .searchable(text: $keysViewModel.searchText)
                .onChange(of: keysViewModel.sortOrder) { _, sortOrder in
                    keysViewModel.sshKeys.sort(using: sortOrder)
                }
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
                KeyCommentEditView(sshKey: sshKey, onEdit: {
                    keysViewModel.loadKeys()
                })
            }
        }
        
        .sheet(isPresented: $isInsertionPresented) {
            KeyInsertionView(isPresented: $isInsertionPresented, onInsert: { name, secret, isPresented in
                let insert = KeysManager.insertKey(name: name, secret: secret)
                if insert {
                    keysViewModel.loadKeys(force: true)
                    isPresented.wrappedValue = false
                }
            })
        }
        .sheet(isPresented: $isCreatedPresented) {
            KeyCreateView(isPresented: $isCreatedPresented, onCreate: { name, comment, isPresented in
                let create = KeysManager.generateKey(name: name, comment: comment)
                if create {
                    keysViewModel.loadKeys(force: true)
                    isPresented.wrappedValue = false
                }
            })
        }
    }
}

#Preview {
    KeysView()
}
