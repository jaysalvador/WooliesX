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
    
    public var minLifeSpan: Int? {
        
        let min = String(self.lifeSpan?.split(separator: " ").first ?? "0").trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Int(min)
    }
}
