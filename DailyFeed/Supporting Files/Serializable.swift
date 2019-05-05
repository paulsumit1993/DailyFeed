//
//  Serializable.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/06/17.
//

import Foundation

protocol Serializable: Codable {
    func serialize() -> Data?
}

extension Serializable {
    func serialize() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    func deserialize(data: Data) throws -> Self {
        let decoder = JSONDecoder()
       return try decoder.decode(Self.self, from: data)
    }
}
