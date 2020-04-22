//
//  UrlParameters.swift
//  WooliesAPI
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import Foundation

public class UrlParameters<T: CodingKey> {
    
    private var params = Array<String>()
    
    public func with(key: T, value: Any?) -> UrlParameters {
        
        if let _value = value {
            
            self.params.append("\(key.stringValue)=\(_value)")
        }
        
        return self
    }
    
    public var flattened: String {
        
        if !self.params.isEmpty {
            
            return "?\(self.params.joined(separator: "&"))"
        }
        else {
            
            return ""
        }
    }
}
