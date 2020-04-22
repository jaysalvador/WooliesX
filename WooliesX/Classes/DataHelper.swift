//
//  DataHelper.swift
//  WooliesXTests
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import WooliesAPI

class DataHelper {

    class func getMockImages(completion: HttpCompletionClosure<[DogImage]>?) {

        let dataPath = Bundle(for: DataHelper.self).path(forResource: "data", ofType: "json") ?? ""
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: dataPath))
            
            let decoder = JSONDecoder()
                        
            let decoded = try decoder.decode([DogImage].self, from: data)
            
            completion?(.success(decoded))
        }
        catch {

            completion?(.failure(HttpError.decoding(error)))
        }
    }
}
