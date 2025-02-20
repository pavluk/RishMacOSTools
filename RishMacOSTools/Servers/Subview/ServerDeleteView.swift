//
//  ServerEditView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 24.11.2024.
//

import SwiftUI

struct ServerDeleteView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var keysViewModel: KeysViewModel
    @State private var deleteKey = false
    @State var server: ServerObject
    var onDelete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image("icon")
           .resizable()
           .frame(width: 64, height: 64)
           .clipShape(RoundedRectangle(cornerRadius: 12))
            Text("server.delete '\(server.host)'?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            HStack {
                Text("button.delete_key")
                Section {
                    Toggle("", isOn: $deleteKey)
                }
            }
            HStack {
                Button(String(localized: "button.cancel")) {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button(action: {
                    if ServersManager.removeServer(host: server.host){
                        if deleteKey {
                            keysViewModel.removeKey(name: server.keyName,showMessage: false)
                        }
                        onDelete();
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    VStack {
                        Text("button.delete_server")
                            .foregroundColor(.red)
                    }
                }
            }.padding(10)
        }
        .padding()
        .frame(maxWidth: 300)
    }
}
