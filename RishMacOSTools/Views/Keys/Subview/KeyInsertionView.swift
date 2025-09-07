//
//  KeyInsertionView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 27.07.2024.
//

import SwiftUI

struct KeyInsertionView: View {
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var secret: String = ""
    var onInsert: (String, String, Binding<Bool>) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Text("label.key_name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,10)
                    TextField("", text: $name)
                        .textFieldStyle(.roundedBorder)
                    Text("label.secret_key")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal,10)
                    TextEditor(text: $secret)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                HStack {
                    Button(String(localized: "button.insert_key")) {
                        onInsert(name, secret,$isPresented)
                    }
                    .disabled(name.isEmpty || secret.isEmpty)
                    Spacer()
                    Button(String(localized: "button.cancel")) {
                        isPresented = false
                    }
                }.padding(15)
            }
            .navigationTitle(String(localized: "button.insert_key"))
            .frame(width: 400, height: 350)
        }
    }
}
