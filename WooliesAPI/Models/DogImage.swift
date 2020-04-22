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
