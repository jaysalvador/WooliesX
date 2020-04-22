//
//  DogImageClient.DogImageRequest.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

extension DogImageClient {
    
    public struct DogImageRequest: Encodable {
        
        public var limit: Int
        
        enum CodingKeys: String, CodingKey {
            
            case limit
        }
        
        var parameters: String {
            
            return UrlParameters()
                    .with(key: CodingKeys.limit, value: self.limit)
                    .flattened
        }
    }
}
