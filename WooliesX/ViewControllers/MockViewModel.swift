//
//  MockViewModel.swift
//  WooliesXTests
//
//  Created by Jay Salvador on 23/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import WooliesAPI

class MockViewModel: ViewModelProtocol {
    
    var isAscending: Bool = true
    
    var error: HttpError?
    
    var images: [DogImage]?
    
    var onUpdated: ViewModelCallback?
    
    var onError: ViewModelCallback?
    
    func getImages() {
        
        DataHelper.getMockImages { [weak self] (response) in
            
            switch response {
                
            case .success(let _images):
                
                self?.images = _images
                
                self?.onUpdated?()
                
            case .failure(let error):
                
                self?.error = HttpError.decoding(error)
                
                self?.onError?()
            }
        }
    }
}
