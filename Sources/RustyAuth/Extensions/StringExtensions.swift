//
//  StringExtensions.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation
import RustyExtensions

extension String {
    
    /* PKCE Spec calls for:
       - 43 to 128 characters
    */
    public var pkceEncoded: String? {
        self.toBase64?
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}
