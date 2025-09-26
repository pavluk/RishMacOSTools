//
//  SettingsView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 19.09.2025.
//

import SwiftUI

/// Settings screen with terminal selector
struct SettingsView: View {
    @AppStorage(SettingsKeys.preferredTerminal) private var preferredTerminal: String = "default"
    @State private var terminals: [TerminalApp] = []

    var body: some View {
        Form {
            Picker("settings.connect_via", selection: $preferredTerminal) {
                ForEach(terminals) { t in
                    Text(t.name).tag(t.id)
                }
            }
        }
        .padding()
        .frame(width: 420, height: 100)
        .onAppear {
            reloadTerminals()
        }
    }

    private func availableTerminals() -> [TerminalApp] {
        TerminalApp.all.filter { $0.path.isEmpty || FileManager.default.fileExists(atPath: $0.path) }
    }

    private func reloadTerminals() {
        terminals = availableTerminals()
        validatePreferred()
    }

    private func validatePreferred() {
        if !terminals.contains(where: { $0.id == preferredTerminal }) {
            preferredTerminal = TerminalApp.defaultTerminal.id
        }
    }
}
