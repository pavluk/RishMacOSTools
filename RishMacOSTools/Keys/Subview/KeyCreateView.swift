//
//  KeyCreateView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 27.07.2024.
//

import SwiftUI

struct KeyCreateView: View {
    @Binding var isPresented: Bool
    @State private var name: String = "id_ed25519"
    @State private var comment: String = "Your.Name"
    var onCreate: (String, String, Binding<Bool>) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    TextField(String(localized: "label.key_name"), text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField(String(localized: "label.key_comment"), text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Button(String(localized: "button.generate_key")) {
                            onCreate(name, comment,$isPresented)
                        }
                        .disabled(name.isEmpty || comment.isEmpty)
                        Spacer()
                        Button(String(localized: "button.cancel")) {
                            isPresented = false
                        }
                    }.padding(20)
                }
            }
            .navigationTitle(String(localized: "button.create_key"))
            .frame(width: 400, height: 200)
        }
    }
}
