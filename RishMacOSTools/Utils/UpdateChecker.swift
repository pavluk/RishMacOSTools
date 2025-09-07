//
//  UpdateChecker.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.09.2025.
//

import Foundation

// Toggle verbose logs (and short cache interval for testing)
private let UPDATE_DEBUG_LOGS = false

/// Result of update check
enum UpdateResult {
    case updateAvailable(GitHubRelease)
    case upToDate
    case failure
}

/// GitHub API DTO
struct GitHubRelease: Decodable, Identifiable {
    let tag_name: String
    let name: String?
    let body: String?
    let html_url: String
    let assets: [Asset]?

    struct Asset: Decodable {
        let name: String
        let browser_download_url: String
        let content_type: String?
    }

    var id: String { html_url }
}

enum UpdateChecker {
    private static let url = URL(string: "https://api.github.com/repos/pavluk/RishMacOSTools/releases/latest")!
    private static let token: String? = nil

    // Cache interval:
    // - 6 hours by default
    // - 1 minute when UPDATE_DEBUG_LOGS == true
    private static let minInterval: TimeInterval = UPDATE_DEBUG_LOGS ? 60 : (6 * 60 * 60)

    private static let kLastCheck    = "UpdateChecker.lastCheck"
    private static let kETag         = "UpdateChecker.etag"
    private static let kLastRelease  = "UpdateChecker.lastReleaseJSON" // NEW: full JSON cache

    // MARK: - Public

    /// Lightweight check that respects the cache and ETag.
    static func checkIfNeeded() async -> UpdateResult {
        // interval gate
        if let last = UserDefaults.standard.object(forKey: kLastCheck) as? Date,
           Date().timeIntervalSince(last) < minInterval {
            log("Skip: last check \(Int(Date().timeIntervalSince(last)))s ago (< \(Int(minInterval))s)")
            return .upToDate
        }

        // do a conditional fetch
        let outcome = await fetchLatestSafely(ignoreCache: false)

        switch outcome {
        case .ok(let rel):
            // got fresh JSON → persist it and ETag already handled inside
            UserDefaults.standard.set(Date(), forKey: kLastCheck)
            return isNewer(rel.tag_name, than: currentVersion()) ? .updateAvailable(rel) : .upToDate

        case .notModified:
            // 304: use cached JSON if available
            if let cached = loadCachedRelease() {
                UserDefaults.standard.set(Date(), forKey: kLastCheck)
                if isNewer(cached.tag_name, than: currentVersion()) {
                    log("304 with cached release → show cached (has body)")
                    return .updateAvailable(cached)
                } else {
                    return .upToDate
                }
            } else {
                // No cached JSON → one-shot fresh fetch without ETag
                log("304 but no cached JSON → one-shot fresh fetch")
                switch await fetchLatestSafely(ignoreCache: true) {
                case .ok(let rel):
                    UserDefaults.standard.set(Date(), forKey: kLastCheck)
                    return isNewer(rel.tag_name, than: currentVersion()) ? .updateAvailable(rel) : .upToDate
                default:
                    return .failure
                }
            }

        case .failure:
            return .failure
        }
    }

    /// Manual check triggered from UI; ignores local cache/ETag.
    static func checkNowIgnoringCache() async -> UpdateResult {
        switch await fetchLatestSafely(ignoreCache: true) {
        case .ok(let rel):
            return isNewer(rel.tag_name, than: currentVersion()) ? .updateAvailable(rel) : .upToDate
        case .notModified:
            if let cached = loadCachedRelease(),
               isNewer(cached.tag_name, than: currentVersion()) {
                return .updateAvailable(cached)
            }
            return .upToDate
        case .failure:
            return .failure
        }
    }

    /// Optional helper for testing: clear local cache keys.
    static func resetCache() {
        UserDefaults.standard.removeObject(forKey: kLastCheck)
        UserDefaults.standard.removeObject(forKey: kETag)
        UserDefaults.standard.removeObject(forKey: kLastRelease)
        log("Cache reset (kLastCheck, kETag, kLastRelease removed)")
    }

    // MARK: - Internals

    private enum FetchOutcome { case ok(GitHubRelease), notModified, failure }

    static func currentVersion() -> String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        log("Current app version: \(v)")
        return v
    }

    private static func normalize(_ v: String) -> [Int] {
        let s = v.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let t = s.hasPrefix("v") ? String(s.dropFirst()) : s
        return t.split(separator: ".").map { Int($0) ?? 0 }
    }

    private static func isNewer(_ a: String, than b: String) -> Bool {
        let A = normalize(a), B = normalize(b)
        for i in 0..<max(A.count, B.count) {
            let ai = i < A.count ? A[i] : 0
            let bi = i < B.count ? B[i] : 0
            if ai != bi {
                log("Compare \(a) vs \(b) → \(ai > bi)")
                return ai > bi
            }
        }
        log("Compare \(a) vs \(b) → false")
        return false
    }

    private static func fetchLatestSafely(ignoreCache: Bool) async -> FetchOutcome {
        var req = URLRequest(url: url)
        req.setValue("RishMacOSTools (macOS)", forHTTPHeaderField: "User-Agent")
        if let t = token, !t.isEmpty { req.setValue("token \(t)", forHTTPHeaderField: "Authorization") }
        if !ignoreCache, let etag = UserDefaults.standard.string(forKey: kETag) {
            req.setValue(etag, forHTTPHeaderField: "If-None-Match")
            log("If-None-Match: \(etag)")
        }

        let cfg = URLSessionConfiguration.ephemeral
        cfg.timeoutIntervalForRequest = 8
        cfg.timeoutIntervalForResource = 10
        let session = URLSession(configuration: cfg)

        do {
            log("Request → \(url.absoluteString)")
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { log("No HTTP response"); return .failure }

            log("HTTP \(http.statusCode)")
            if http.statusCode == 304 { return .notModified }
            if http.statusCode == 429 { log("Rate limited (429)"); return .failure }
            if http.statusCode == 403,
               http.value(forHTTPHeaderField: "X-RateLimit-Remaining") == "0" {
                log("Rate limit exceeded (403)"); return .failure
            }
            guard (200...299).contains(http.statusCode) else { log("Unexpected status"); return .failure }

            if let etag = http.value(forHTTPHeaderField: "Etag") {
                UserDefaults.standard.set(etag, forKey: kETag)
                log("Saved ETag: \(etag)")
            }

            // Decode JSON
            let decoder = JSONDecoder()
            guard let rel = try? decoder.decode(GitHubRelease.self, from: data) else {
                log("JSON decode failed"); return .failure
            }
            log("Remote tag: \(rel.tag_name)")

            // NEW: save full JSON for future 304
            saveCachedReleaseJSON(data)

            return .ok(rel)
        } catch {
            log("Network error: \(error.localizedDescription)")
            return .failure
        }
    }

    // MARK: - Cached release JSON

    private static func saveCachedReleaseJSON(_ data: Data) {
        UserDefaults.standard.set(data, forKey: kLastRelease)
        // no log flood; keep quiet unless debugging
        log("Cached full release JSON (\(data.count) bytes)")
    }

    private static func loadCachedRelease() -> GitHubRelease? {
        guard let data = UserDefaults.standard.data(forKey: kLastRelease) else { return nil }
        return try? JSONDecoder().decode(GitHubRelease.self, from: data)
    }

    private static func log(_ s: String) {
        if UPDATE_DEBUG_LOGS { print("[UpdateChecker]", s) }
    }
}
