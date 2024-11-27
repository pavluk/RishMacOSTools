//
//  KeyCommentEditView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 27.07.2024.
//

import SwiftUI

struct KeyCommentEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var sshKeyEdit: KeyObject
    @State private var comment: String = ""
    var onEdit: () -> Void
    init(sshKey: KeyObject, onEdit: @escaping () -> Void) {
        self.sshKeyEdit = sshKey
        _comment = State(initialValue: sshKey.keyComment)
        self.onEdit = onEdit
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    Text("label.key_name \(sshKeyEdit.keyName)")
                    TextField(String(localized: "label.key_comment"), text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button(String(localized: "button.key_comment_edit")) {
                            editComment()
                        }
                        .disabled(comment.isEmpty || comment == sshKeyEdit.keyComment)
                        
                        Spacer()
                        
                        Button(String(localized: "button.cancel")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }.padding(20)
                }
            }
            .navigationTitle(String(localized: "button.key_comment_edit"))
            .frame(width: 400, height: 200)
        }.frame(width: 400, height: 200)
    }
    
    func editComment() {
        guard !comment.isEmpty else { return }
        guard sshKeyEdit.keyComment != comment else {
            presentationMode.wrappedValue.dismiss()
            return
        }
        let success = KeysManager.editPublicKeyComment(keyName: sshKeyEdit.keyName, newComment: comment)
        if success {
            sshKeyEdit.keyComment = comment
            onEdit()
            presentationMode.wrappedValue.dismiss()
        }
    }
}
