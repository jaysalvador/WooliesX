//
//  UrlSession.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol URLSessionProtocol: class {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

/// Encapsulates the URLSession to a `URLSessionDataTask` class defined in protocol `URLSessionProtocol`
/// Exposes the `dataTask` function for `URLSession` normally defined in `URLSessionDataTask`
extension URLSession: URLSessionProtocol {
    
    /// A convenience function that can immediately call `dataTask` from a `URLSession` object
    /// - Parameter request: `URLRequest` object`
    /// - Parameter completionHandler: response closure with data, response, and error values
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        // The double casting is necessary because both methods have the same name and the compiler gets lost
        
        return ((dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol)
    }
}
