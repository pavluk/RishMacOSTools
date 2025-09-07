//
//  UpdateSheet.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.09.2025.
//

import SwiftUI

/// A modal sheet that displays details about an available update.
struct UpdateSheet: View {
    let release: GitHubRelease
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Title & version
            Text(LocalizedStringKey("update.available"))
                .font(.title2)
                .fontWeight(.bold)

            Text(release.name ?? release.tag_name)
                .font(.headline)

            // Body (GitHub-like list rendering or plain markdown)
            bodySection()

            // Actions
            HStack {
                Link(LocalizedStringKey("update.download"), destination: preferredDownloadURL())
                    .buttonStyle(.borderedProminent)

                Button(LocalizedStringKey("update.later"), role: .cancel, action: onClose)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(20)
        .frame(minWidth: 420)
    }

    // MARK: - Body rendering

    @ViewBuilder
    private func bodySection() -> some View {
        let raw = (release.body ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = normalizeGitHubMarkdown(raw)

        ScrollView {
            if let items = parseBulletItems(from: normalized), !items.isEmpty {
                // Render GitHub-like bullet list
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("•").fontWeight(.semibold)
                            listItemText(fromMarkdown: item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(8)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else if !normalized.isEmpty, let attributed = parseMarkdown(normalized) {
                Text(attributed)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else if !normalized.isEmpty {
                Text(normalized)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .frame(minHeight: 120, maxHeight: 260)
    }

    // MARK: - Helpers

    /// Prefer a DMG asset; fall back to the release page.
    private func preferredDownloadURL() -> URL {
        if let u = release.assets?
            .first(where: { $0.name.lowercased().hasSuffix(".dmg") })?
            .browser_download_url,
           let url = URL(string: u) {
            return url
        }
        return URL(string: release.html_url)!
    }

    /// Normalize GitHub markdown line endings and collapse extra blank lines.
    private func normalizeGitHubMarkdown(_ s: String) -> String {
        var text = s
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        while text.contains("\n\n\n") { text = text.replacingOccurrences(of: "\n\n\n", with: "\n\n") }
        return text
    }

    /// Try to extract bullet items like "- ..." / "* ..." / "+ ...".
    /// Returns nil if the content is not a list (to fall back to regular markdown).
    private func parseBulletItems(from text: String) -> [String]? {
        let lines = text.components(separatedBy: .newlines)
        let bullets = lines.compactMap { line -> String? in
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard let first = trimmed.first, ["-", "*", "+"].contains(first) else { return nil }
            // Require a space after the marker to avoid false positives: "-text" vs "- text"
            let afterMarker = trimmed.dropFirst().drop(while: { $0 == " " })
            // only accept if there was at least one space
            if trimmed.count > afterMarker.count + 1 {
                // remove exactly one leading marker and one following space
                let content = String(trimmed.dropFirst(2)) // "- " removed
                return content
            }
            return nil
        }

        // Heuristic: treat as list only if >= 2 bullet lines discovered
        return bullets.count >= 2 ? bullets : nil
    }

    /// Render one bullet line as markdown (keeps **bold**, links, etc).
    @ViewBuilder
    private func listItemText(fromMarkdown md: String) -> some View {
        if let attr = parseMarkdown(md) {
            Text(attr)
        } else {
            Text(md)
        }
    }

    /// Parse markdown into AttributedString with full GitHub-like syntax.
    private func parseMarkdown(_ body: String) -> AttributedString? {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        let opts = AttributedString.MarkdownParsingOptions(
            allowsExtendedAttributes: true,
            interpretedSyntax: .full,
            failurePolicy: .returnPartiallyParsedIfPossible,
            languageCode: lang
        )
        return try? AttributedString(markdown: body, options: opts)
    }
}
