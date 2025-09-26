//
//  TerminalApp.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 19.09.2025.
//

import Foundation
import SwiftUI


/// Known terminal applications (with path and localization key)
struct TerminalApp: Identifiable {
    let id: String
    let name: LocalizedStringKey
    let path: String
}

extension TerminalApp {
    static let all: [TerminalApp] = [
        .init(id: "default",   name: "settings.terminal.default_with_terminal", path: "/System/Applications/Utilities/Terminal.app"),
        .init(id: "iterm",     name: "settings.terminal.iterm",     path: "/Applications/iTerm.app"),
        .init(id: "alacritty", name: "settings.terminal.alacritty", path: "/Applications/Alacritty.app"),
        .init(id: "kitty",     name: "settings.terminal.kitty",     path: "/Applications/kitty.app"),
    ]
    
    static var defaultTerminal: TerminalApp {
        all.first { $0.id == "default" }!
    }
    
    static func byId(_ id: String?) -> TerminalApp {
        if let id, let term = all.first(where: { $0.id == id }) {
            return term
        }
        return defaultTerminal
    }
}
