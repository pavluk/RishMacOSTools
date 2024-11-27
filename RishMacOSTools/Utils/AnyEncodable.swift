//
//  AnyEncodable.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 26.11.2024.
//

struct AnyEncodable: Encodable {
    let value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
