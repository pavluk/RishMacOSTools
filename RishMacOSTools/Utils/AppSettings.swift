//
//  AppSettings.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 22.09.2025.
//

import SwiftUI

final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @AppStorage(SettingsKeys.preferredTerminal)
    var preferredTerminal: String = "default"
}
