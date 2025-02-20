//
//  ServerEditView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 24.11.2024.
//

import SwiftUI

struct ServerEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var server: ServerObject
    @State private var comment: String = ProcessInfo.processInfo.userName
    @State private var addKeysToAgent: Bool
    @State private var keys: [String] = [
        String(localized: "option.key.select"),
        String(localized: "button.create_key")
    ]
    var onEdit: () -> Void
    private let labelWidth: CGFloat = 140
    private let originalServer: ServerObject
    
    init(server: ServerObject, onEdit: @escaping () -> Void) {
        _server = State(initialValue: server)
        self.originalServer = _server.wrappedValue
        self.onEdit = onEdit
        self._addKeysToAgent = State(initialValue: (server.additions["AddKeysToAgent"]?.lowercased() == "yes"))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(spacing: 10) {
                    HStack {
                        Text(String(localized: "label.server_host"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $server.host)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .disabled(true)
                    }
                    
                    HStack {
                        Text(String(localized: "label.server_hostname"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $server.hostname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .onChange(of: server.hostname) { _, newValue in
                                server.hostname = StaticHelper.filterToLatin(newValue)
                            }
                    }
                    
                    HStack {
                        Text(String(localized: "label.server_user"))
                            .frame(width: labelWidth, alignment: .leading)
                        TextField("", text: $server.user)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .onChange(of: server.user) { _, newValue in
                                server.user = StaticHelper.filterToLatin(newValue)
                            }
                    }
                    
                    
                    HStack {
                        Text(String(localized: "label.key_name"))
                            .frame(width: labelWidth, alignment: .leading)
                        Picker("", selection: $server.keyName) {
                            ForEach(keys, id: \.self) { key in
                                   Text(key).tag(key)
                               }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    if server.keyName ==  String(localized: "button.create_key") {
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
                        Button(String(localized: "button.server_edit")) {
                            editServer()
                        }
                        .disabled(checkDisabled())
                        Spacer()
                        Button(String(localized: "button.cancel")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }.padding(10)
                }
            }
            .navigationTitle(String(localized: "title.server_edit \(server.host)"))
            .frame(width: 350, height: 220)
            .onAppear {
                let keyObjects = KeysManager.getKeys()
                if !keyObjects.isEmpty {
                    keys.append(contentsOf: keyObjects.map { $0.keyName }.sorted { $0.lowercased() < $1.lowercased() })
                }
            }
        }
        
    }
    private func editServer() {
        if server.keyName == String(localized: "option.key.select"){
            StaticHelper.showAlert(message: String(localized: "server.key_not_found"), error: true)
            return
        }
        var keyName = server.keyName
        if server.keyName == String(localized: "button.create_key"){
            keyName = server.host + "-newkey"
            let create = KeysManager.generateKey(
                name: keyName,
                comment: comment,
                message: false
            )
            if create {
                _ = KeysManager.getKeys(force: true)
            }
        }
        server.keyName = keyName
        if addKeysToAgent{
            server.additions["AddKeysToAgent"] = "Yes"
        }
        else{
            server.additions.removeValue(forKey: "AddKeysToAgent")
        }
        let success = ServersManager.editServer(server: &server)
        if success {
            onEdit()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func checkDisabled() -> Bool{
       var result = (server.host == originalServer.host &&
                   server.hostname == originalServer.hostname &&
                   server.user == originalServer.user &&
                   server.keyName == originalServer.keyName)
                  || server.hostname.isEmpty
                  || server.user.isEmpty
                  || server.keyName.isEmpty
                  || server.keyName == String(localized: "option.key.select")
                  || (server.keyName == String(localized: "button.create_key")
                      && server.key.keyComment.isEmpty)
        
        if addKeysToAgent{
            if originalServer.additions["AddKeysToAgent"] == nil{
                result = false
            }
        }
        else{
            if let value = originalServer.additions["AddKeysToAgent"], value.lowercased() == "yes" {
                result = false
            }
        }
        
        
        return result
    }
}
