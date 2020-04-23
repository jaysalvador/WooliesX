//
//  Breed.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

public struct Breed: Codable {
    
    public var id: Int?
    public var name: String?
    public var lifeSpan: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case lifeSpan = "life_span"
    }
}

extension Breed {
    
    public static let greatestLifeSpan: Int = 999
    
    public var minLifeSpan: Int? {
        
        let min = String(self.lifeSpan?.split(separator: " ").first ?? "0").trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Int(min)
    }
    
    public var maxLifeSpan: Int? {
        
        if let items = self.lifeSpan?.split(separator: " "), items.count > 2 {
            
            let max = String(self.lifeSpan?.split(separator: " ")[2] ?? "0").trimmingCharacters(in: .whitespacesAndNewlines)
            
            return Int(max) ?? self.minLifeSpan
        }
        
        return self.minLifeSpan
    }
}

extension Breed: Equatable {
    
    public static func == (lhs: Breed, rhs: Breed) -> Bool {
        
        return lhs.id == rhs.id
    }
    
}
