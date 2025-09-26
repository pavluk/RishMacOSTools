//
//  ContentView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.05.2024.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @StateObject var keysViewModel = KeysViewModel()
    @State private var updateRelease: GitHubRelease?

    // Select TabViewStyle depending on macOS version
    private var adaptiveTabViewStyle: some TabViewStyle {
        if #available(macOS 15.0, *) {
            return .sidebarAdaptable
        } else {
            return .automatic
        }
    }

    var body: some View {
        VStack {
            TabView {
                ServersView()
                    .tabItem { Label(String(localized: "view.servers_name"), systemImage: "server.rack") }

                KeysView()
                    .tabItem { Label(String(localized: "view.keys_name"), systemImage: "key.fill") }

                AboutView()
                .tabItem { Label(String(localized: "about.title"), systemImage: "info.circle") }
            }
            .tabViewStyle(adaptiveTabViewStyle)
            .frame(maxHeight: .infinity)
            .environmentObject(keysViewModel)
        }
        .task {
            _ = StaticHelper.ensureSSHScaffold()

            let result = await UpdateChecker.checkIfNeeded()
            await MainActor.run { handleUpdateResult(result) }
        }
        .sheet(item: $updateRelease) { rel in
            UpdateSheet(release: rel) { updateRelease = nil }
        }
    }

    private func handleUpdateResult(_ result: UpdateResult) {
        switch result {
        case .updateAvailable(let rel):
            updateRelease = rel
        case .upToDate, .failure:
            break
        }
    }
}
