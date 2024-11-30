//
//  ITermProfile.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 26.11.2024.
//

import Foundation
import Cocoa


struct ITermProfileObject: Codable {

    let guid: String
    let name: String
    let workingDirectory: String
    let command: String
    let customCommand: String
    let rows: Int
    let columns: Int

    init(server: ServerObject) {
        self.guid = server.id.uuidString
        self.name = server.host.capitalized
        self.command = "ssh \(server.host)"
        self.customCommand = "Yes"
        self.workingDirectory = "/Users/\(NSUserName())"
        self.columns = 140
        self.rows = 40
    }

    enum CodingKeys: String, CodingKey {
        case columns = "Columns"
        case rows = "Rows"
        case guid = "Guid"
        case command = "Command"
        case customCommand = "Custom Command"
        case name = "Name"
        case workingDirectory = "Working Directory"
    }
}
