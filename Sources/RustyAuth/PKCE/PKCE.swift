//
//  PKCE.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation
import CryptoKit
import RustyExtensions

public enum PKCE {
    
    public static func createCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64EncodedString()
    }
    
    public static func createCodeChallenge(from: String) -> String? {
        guard let data = from.data(using: .utf8) else { return nil }
        let digest = SHA256.hash(data: data)
        let result = Data(digest).pkceEncoded
        
        return result
    }
}
