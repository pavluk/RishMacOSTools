//
//  ContextMenu.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 28.07.2024.
//

import SwiftUI

struct KeyContextMenu: View {
    var sshKey: KeyObject
    var onEdit: () -> Void
    var onDelete: () -> Void
    var body: some View {
        VStack {
            Button(action: {
                StaticHelper.copyToClipboard(text: sshKey.publicKey, name: String(localized: "label.key_public"))
            }) {
                Text("label.key_public")
                Image(systemName: "doc.on.doc")
            }
            Button(action: {
                StaticHelper.copyToClipboard(text: sshKey.serverCommand, name: String(localized: "label.server_command"))
            }) {
                VStack {
                    Text("label.server_command")
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.secondary)
                }
            }
            Button(action: {
               onEdit()
            }) {
                Text("button.key_edit_comment")
                Image(systemName: "pencil")
            }
            Button(action: {
                onDelete();
            }) {
                VStack {
                    Text("button.delete_key")
                        .foregroundColor(.red)
                    Image(systemName: "trash.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

