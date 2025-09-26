//
//  TerminalDetector.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 19.09.2025.
//

import Foundation

/// Returns only installed terminals (always keeps `default`)
func availableTerminals() -> [TerminalApp] {
    TerminalApp.all.filter { $0.id == "default" || FileManager.default.fileExists(atPath: $0.path) }
}
