//
//  HttpClient.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

/// function type for the return value
/// `T` can be any model object to represent the response from JSON
/// `HTTPError` returns as the error type
public typealias HttpCompletionClosure<T> = ((Result<T, HttpError>) -> Void)

/// Protocol to define function signatures for `HttpClient`
public protocol HttpClientProtocol {
    
    func request<T>(_ type: T.Type, endpoint: String, httpMethod: HttpMethod, headers: Dictionary<String, String>?, onCompletion: HttpCompletionClosure<T>?) where T: Decodable
}

/// Class that helps retrieve JSON data and decodes into the specified response object
public class HttpClient: HttpClientProtocol {
    
    private let baseUrl: String
    
    private let urlSession: URLSessionProtocol
    
    /// Convenience init with the pre-assigned `baseUrl` and `urlSession`
    public convenience init?() {
        
        self.init(
            baseUrl: "https://api.thedogapi.com/v1",
            urlSession: URLSession.shared)
    }
    
    /// Creates a custom instance of `HttpClient`
    /// - Parameter _baseUrl: path of the API
    /// - Parameter _urlSession: `URLSession` Object
    init(baseUrl _baseUrl: String, urlSession _urlSession: URLSessionProtocol) {
        
        self.baseUrl = _baseUrl
        
        self.urlSession = _urlSession
    }
    
    /// Creates an HTTP request to a particular service endpoint
    /// - Parameter type: The class type you want to bind the response to
    /// - Parameter endpoint: API service enpoint path
    /// - Parameter httpMethod: HTTP Method (get, post, put, delete)
    /// - Parameter headers: additional HTTP headers
    /// - Parameter onCompletion: completion closure with `Result` containing the binded model or error states
    public func request<T>(_ type: T.Type, endpoint: String, httpMethod: HttpMethod, headers: Dictionary<String, String>?, onCompletion: HttpCompletionClosure<T>?) where T: Decodable {
        
        DispatchQueue.background.async {
            
            if let url = URL(string: self.baseUrl + endpoint) {
                
                var request = URLRequest(url: url)
                
                request.httpMethod = httpMethod.rawValue
                
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                if let headers = headers {
                    
                    for (key, value) in headers {
                        
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                
                self.send(request, returnType: type, onCompletion: onCompletion)
            }
        }
    }
    
    /// Sends requests to the API service
    /// - Parameter request: `URLRequest` object
    /// - Parameter returnType: class type your response would be binded to
    /// - Parameter onCompletion: completion closure with `Result` containing the binded model or error states
    private func send<T>(_ request: URLRequest?, returnType: T.Type, onCompletion: HttpCompletionClosure<T>?) where T: Decodable {
        
        guard let request = request else {
            
            onCompletion?(.failure(HttpError.nilRequest))
            
            return
        }
        
        let task = urlSession.dataTask(with: request) { (data, urlResponse, error) -> Void in
                        
            if let httpUrlResponse = urlResponse as? HTTPURLResponse, httpUrlResponse.statusCode < 400 {
                
                if let data = data {
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        
                        let decoded = try decoder.decode(returnType, from: data)
                        
                        DispatchQueue.main.async {
                                                        
                            onCompletion?(.success(decoded))
                        }
                    }
                    catch {
                        
                        DispatchQueue.main.async {
                                                                                    
                            onCompletion?(.failure(HttpError.decoding(error)))
                        }
                    }
                    
                    return
                }
            }
            
            var statusCode: Int?
            
            if let httpUrlResponse = urlResponse as? HTTPURLResponse {
                
                statusCode = httpUrlResponse.statusCode
            }
            
            DispatchQueue.main.async {
                
                onCompletion?(.failure(HttpError.unknown(statusCode: statusCode, data: data)))
            }
        }
        
        task.resume()
    }
}
