//
//  ServerCreateView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 23.11.2024.
//

import SwiftUI

struct ServerCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var host: String = ""
    @State private var hostname: String = ""
    @State private var user: String = "root"
    @State private var selectedKey: String = String(localized: "option.key.select")
    @State private var comment: String = ProcessInfo.processInfo.userName
    @State private var addKeysToAgent: Bool = true
    @State private var keys: [String] = [
        String(localized: "option.key.select"),
        String(localized: "button.create_key")
    ]
    var onCreate: () -> Void
    private let labelWidth: CGFloat = 140
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(spacing: 10) {
                    HStack {
                        Text(String(localized: "label.server_host"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $host)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .onChange(of: host) { _, newValue in
                                host = StaticHelper.filterToLatin(newValue)
                            }
                    }

                    HStack {
                        Text(String(localized: "label.server_hostname"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $hostname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .onChange(of: hostname) { _, newValue in
                                hostname = StaticHelper.filterToLatin(newValue)
                            }
                    }

                    HStack {
                        Text(String(localized: "label.server_user"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $user)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .onChange(of: user) { _, newValue in
                                user = StaticHelper.filterToLatin(newValue)
                            }
                    }


                    HStack {
                        Text(String(localized: "label.key_name"))
                            .frame(width: labelWidth, alignment: .leading)
                        Picker("", selection: $selectedKey) {
                            ForEach(keys, id: \.self) { key in
                                Text(key).tag(key)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    if selectedKey ==  String(localized: "button.create_key") {
                        HStack {
                            Text(String(localized: "label.key_comment"))
                                .frame(width: labelWidth, alignment: .leading)
                            TextField("", text: $comment)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 5)
                        }
                    }
                    HStack {
                        Text("")
                            .frame(width: labelWidth, alignment: .leading)
                        Section {
                            Toggle("label.server_add_keys_to_agent", isOn: $addKeysToAgent)
                        }
                    }
                    HStack {
                        Button(String(localized: "button.server_create")) {
                            createServer()
                        }
                        .disabled(host.isEmpty
                                  || hostname.isEmpty
                                  || user.isEmpty
                                  || selectedKey.isEmpty
                                  || selectedKey == String(localized: "option.key.select")
                        || (selectedKey == String(localized: "button.create_key") && comment.isEmpty))
                        Spacer()
                        Button(String(localized: "button.cancel")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }.padding(10)
                }
            }
            .navigationTitle(String(localized: "button.server_create"))
            .frame(width: 350, height: 220)
            .onAppear {
                let keyObjects = KeysManager.getKeys()
                if !keyObjects.isEmpty {
                    keys.append(contentsOf: keyObjects.map { $0.keyName }.sorted { $0.lowercased() < $1.lowercased() })
                }
            }
        }
        
    }
    private func createServer() {
        if selectedKey == String(localized: "option.key.select"){
            StaticHelper.showAlert(message: String(localized: "server.key_not_found"), error: true)
            return
        }
        var keyName = selectedKey
        if selectedKey == String(localized: "button.create_key"){
             keyName = host + "-key"
            let create = KeysManager.generateKey(
                name: keyName,
                comment: comment,
                message: false
            )
            if create {
                _ = KeysManager.getKeys(force: true)
            }
        }
        let success = ServersManager.createServer(
            host: host,
            hostname: hostname,
            user: user,
            key: keyName,
            addKeysToAgent: addKeysToAgent
        )
        if success {
            onCreate()
            presentationMode.wrappedValue.dismiss()
        }
    }
}
