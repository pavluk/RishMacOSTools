//
//  AboutView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 26.09.2025.
//

import SwiftUI

struct AboutView: View {
    @State private var updateRelease: GitHubRelease?
    var body: some View {
        VStack(spacing: 8) {
            
            Image("rish")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.purple)

            Text("RishMacOSTools")
                .font(.title2)
                .bold()

            Text(String(localized: "author_name"))
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
                Text(String(localized: "about.version \(version)"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Divider()

            VStack(spacing: 8) {
                Link(
                    String(localized: "rish_link_text"),
                    destination: URL(string: "https://rish.su/?utm_source=application")!
                )
                Link(
                    String(localized: "github_link_text"),
                    destination: URL(string: "https://github.com/pavluk/RishMacOSTools")!
                )
            }
            .font(.footnote)

            Spacer()
            Button(String(localized: "update.check")) {
                Task {
                    let result = await UpdateChecker.checkNowIgnoringCache()
                    await MainActor.run {
                        switch result {
                        case .updateAvailable(let rel):
                            updateRelease = rel
                        case .upToDate:
                            StaticHelper.showAlert(message: String(localized: "update.none"))
                        case .failure:
                            StaticHelper.showAlert(message: String(localized: "update.error"))
                        }
                    }
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(width: 320, height: 300)
    }
}
