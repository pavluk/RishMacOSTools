//
//  GitHubRelease.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.09.2025.
//

import Foundation

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
