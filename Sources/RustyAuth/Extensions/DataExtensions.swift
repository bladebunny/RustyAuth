//
//  File.swift
//  
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

extension Data {
    
    public var pkceEncoded: String {
        self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
