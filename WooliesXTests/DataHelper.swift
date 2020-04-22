//
//  DataHelper.swift
//  WooliesXTests
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import WooliesAPI

typealias HelperCompletionClosure = ((Result<[DogImage], Error>) -> Void)

class DataHelper {

    class func getMockImages(completion: HelperCompletionClosure?) {

        let dataPath = Bundle(for: DataHelper.self).path(forResource: "data", ofType: "json") ?? ""
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: dataPath))
            
            let decoder = JSONDecoder()
                        
            let decoded = try decoder.decode([DogImage].self, from: data)
            
            completion?(.success(decoded))
        }
        catch {

            completion?(.failure(error))
        }
    }
}
