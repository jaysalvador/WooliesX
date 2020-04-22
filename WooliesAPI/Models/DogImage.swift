//
//  DogImage.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

public struct DogImage: Codable {
    
    public var id: String?
    public var url: String?
    public var width: Int?
    public var height: Int?
    public var breeds: [Breed]?
}

extension DogImage {
    
    public var firstBreed: Breed? {
        
        return self.breeds?.sorted { ($0.minLifeSpan ?? 0) < ($1.minLifeSpan ?? 0) }.first
    }
    
    public var lastBreed: Breed? {
        
        return self.breeds?.sorted { ($0.minLifeSpan ?? 0) > ($1.minLifeSpan ?? 0) }.first
    }
}

extension DogImage: Equatable {
    
    public static func == (lhs: DogImage, rhs: DogImage) -> Bool {
        
        return lhs.id == rhs.id
    }
}
