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
    var body: some View {
        VStack {
            if ServersManager.isITermInstalled(){
                Button(action: {
                    ServersManager.exportProfiles(profiles: [server]);
                }) {
                    Text("button.server_export.iterm")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            Button(action: {
                onEdit();
            }) {
                Text("button.server_edit")
                Image(systemName: "pencil")
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
