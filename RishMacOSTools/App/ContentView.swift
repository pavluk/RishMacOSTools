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

    var body: some View {
        VStack {
            TabView {
                ServersView()
                    .tabItem { Text(String(localized: "view.servers_name")) }
                KeysView()
                    .tabItem { Text(String(localized: "view.keys_name")) }
            }
            .tabViewStyle(.automatic)
            .frame(maxHeight: .infinity)
            .environmentObject(keysViewModel)

            FooterView(updateRelease: $updateRelease)
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
        case .upToDate:
            break
        case .failure:
            break
        }
    }
}
