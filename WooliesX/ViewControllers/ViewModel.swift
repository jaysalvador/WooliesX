//
//  ViewModel.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation
import WooliesAPI

public typealias ViewModelCallback = (() -> Void)

public protocol ViewModelProtocol {
    
    // MARK: - Data
    
    var isAscending: Bool { get set }
    
    var error: HttpError? { get }
    
    var images: [DogImage]? { get }
    
    // MARK: - Callbacks
    
    var onUpdated: ViewModelCallback? { get set }
    
    var onError: ViewModelCallback? { get set }
    
    // MARK: - Functions
    
    func getImages()
}

class ViewModel: ViewModelProtocol {
    
    private var client: DogImageClientProtocol?
    
    // MARK: - Data
    
    var isAscending: Bool
    
    private(set) var error: HttpError?
    
    private(set) var images: [DogImage]?
    
    // MARK: - Callbacks
    
    var onUpdated: ViewModelCallback?
    
    var onError: ViewModelCallback?
    
    // MARK: - Init
    
    convenience init() {
        
        self.init(client: DogImageClient())
    }
    
    init(client _client: DogImageClientProtocol?) {
        
        self.client = _client
        
        self.isAscending = true
    }
    
    // MARK: - Functions
    
    func getImages() {
        
        self.client?.getImages { [weak self] response in
            
            switch response {
            case .success(let images):
            
                self?.images = images
                
                self?.onUpdated?()
                
            case .failure(let error):
                
                self?.error = error
                
                self?.onError?()
            }
        }
    }
}
