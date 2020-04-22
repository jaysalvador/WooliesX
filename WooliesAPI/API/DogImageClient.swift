//
//  DogImageClient.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

public protocol DogImageClientProtocol {
    
    func getImages(onCompletion: HttpCompletionClosure<[DogImage]>?)
}

public class DogImageClient: HttpClient, DogImageClientProtocol {
    
    public func getImages(onCompletion: HttpCompletionClosure<[DogImage]>?) {
        
        let request = DogImageClient.DogImageRequest(limit: 50)
        
        let endpoint = "/images/search\(request.parameters)"
        
        self.request(
            [DogImage].self,
            endpoint: endpoint,
            httpMethod: .get,
            headers: nil,
            onCompletion: onCompletion
        )
    }
}
