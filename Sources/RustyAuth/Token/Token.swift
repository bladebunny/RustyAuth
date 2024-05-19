//
//  Token.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

public struct AccessToken: CustomDebugStringConvertible {
        
    public var token: String
    public var scope: String?
    public var type: String?
    
    public var debugDescription: String {
        """
        Token: \(self.token)
        Scope: \(self.scope ?? String.empty)
        Type: \(self.type ?? String.empty)
        """
    }
}
