//
//  RishMacOSToolsApp.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.05.2024.
//

import SwiftUI

@main
struct RishMacOSToolsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            SettingsView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button(String(localized: "about.title")) {
                    appDelegate.showAboutWindow()
                }
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var aboutWindow: NSWindow?

    @objc func showAboutWindow() {
        if aboutWindow == nil {
            let hosting = NSHostingController(rootView: AboutView())
            aboutWindow = NSWindow(contentViewController: hosting)
            aboutWindow?.title = String(localized: "about.title")
            aboutWindow?.styleMask = [.titled, .closable, .miniaturizable]
            aboutWindow?.setContentSize(NSSize(width: 320, height: 300))
        }
        aboutWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
