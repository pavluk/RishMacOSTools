//
//  ServerCreateView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 23.11.2024.
//

import SwiftUI

struct ServerCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var keysViewModel: KeysViewModel

    @State private var host: String = ""
    @State private var hostname: String = ""
    @State private var user: String = "root"

    private let tagSelect  = "__select__"
    private let tagCreate  = "__create__"

    @State private var selectedKey: String = "__select__"

    @State private var comment: String = ProcessInfo.processInfo.userName
    @State private var addKeysToAgent: Bool = true

    @State private var keys: [String] = []

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
                                host = StaticHelper.filterToLatin(newValue).lowercased()
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
                            Text(String(localized: "option.key.select")).tag(tagSelect)
                            Text(String(localized: "button.create_key")).tag(tagCreate)
                            ForEach(keys, id: \.self) { key in
                                Text(key).tag(key)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    if selectedKey == tagCreate {
                        HStack {
                            Text(String(localized: "label.key_comment"))
                                .frame(width: labelWidth, alignment: .leading)
                            TextField("", text: $comment)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 5)
                        }
                    }

                    HStack {
                        Text("").frame(width: labelWidth, alignment: .leading)
                        Toggle(String(localized: "label.server_add_keys_to_agent"), isOn: $addKeysToAgent)
                            .toggleStyle(.checkbox)
                    }

                    HStack {
                        Button(String(localized: "button.server_create")) {
                            createServer()
                        }
                        .disabled(
                            host.isEmpty ||
                            hostname.isEmpty ||
                            user.isEmpty ||
                            selectedKey == tagSelect ||
                            (selectedKey == tagCreate && comment.isEmpty)
                        )

                        Spacer()

                        Button(String(localized: "button.cancel")) {
                            dismiss()
                        }
                    }
                    .padding(10)
                }
            }
            .navigationTitle(String(localized: "button.server_create"))
            .frame(width: 350, height: 220)
            .onAppear {
                let keyObjects = KeysManager.getKeys()
                if !keyObjects.isEmpty {
                    keys.append(contentsOf: keyObjects
                        .map { $0.keyName }
                        .sorted { $0.lowercased() < $1.lowercased() })
                }
            }
        }
    }

    private func createServer() {
        if selectedKey == tagSelect {
            StaticHelper.showAlert(message: String(localized: "server.key_not_found"), error: true)
            return
        }

        let keyName: String
        if selectedKey == tagCreate {
            keyName = host + "-key"
            let created = KeysManager.generateKey(
                name: keyName,
                comment: comment,
                message: false
            )
            if created {
                keysViewModel.loadKeys(force: true)
            }
        } else {
            keyName = selectedKey
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
            dismiss()
        }
    }
}
