//
//  FooterView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.09.2025.
//

// FooterView.swift
import SwiftUI

struct FooterView: View {
    @Binding var updateRelease: GitHubRelease?

    var body: some View {
        HStack(alignment: .center) {
            // LEFT: logo + title/author + button under title
            HStack(alignment: .center, spacing: 12) {
                Image("rish")
                    .resizable()
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 6) {
                    Text("RishMacOSTools")
                        .fontWeight(.bold)
                    Text(String(localized: "author_name"))

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
            }

            Spacer()

            // RIGHT: links stacked and right-aligned
            VStack(alignment: .trailing, spacing: 6) {
                Link(
                    String(localized: "rish_link_text"),
                    destination: URL(string: "https://rish.su/?utm_source=application")!
                )
                Link(
                    String(localized: "github_link_text"),
                    destination: URL(string: "https://github.com/pavluk/RishMacOSTools")!
                )
            }
        }
        .padding(.vertical, 0)
        .padding(.bottom, 5)
        .padding(.horizontal, 20)
    }
}
