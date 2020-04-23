//
//  Array.swift
//  WooliesX
//
//  Created by Jay Salvador on 23/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import WooliesAPI

extension Array where Element == DogImage {
    
    func sorted(ascending: Bool = true) -> [Element] {

        return self.sorted {

            let firstMinLifeSpan = $0.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan
            
            let secondMinLifeSpan = $1.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan
            
            let firstMaxLifeSpan = $0.firstBreed?.maxLifeSpan ?? Breed.greatestLifeSpan
            
            let secondMaxLifeSpan = $1.firstBreed?.maxLifeSpan ?? Breed.greatestLifeSpan
            
            let firstName = $0.firstBreed?.name ?? "ZZZZ"
            
            let secondName = $1.firstBreed?.name ?? "ZZZZ"
            
            let firstId = $0.firstBreed?.id ?? Int.max
            
            let secondId = $1.firstBreed?.id ?? Int.max
            
            let firstImage = (firstMinLifeSpan, firstMaxLifeSpan, firstName, firstId)
            
            let secondImage = (secondMinLifeSpan, secondMaxLifeSpan, secondName, secondId)
            
            if ascending {
                
                return firstImage < secondImage
            }
            else {
                
                return firstImage > secondImage
            }
        }
    }
}
