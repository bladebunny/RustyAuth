//
//  URLServices.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

public struct URLServices {
    
    // MARK: - Properties
    let config: PKCEConfig
        
    // MARK: - Init
    public init(config: PKCEConfig) {
        self.config = config
    }

    // MARK: - URL
    public func createAuthURL(codeChallenge: String) -> URL {
        
        var components = URLComponents(string: self.config.authorizeUrl)!

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: AuthKeys.clientID, value: self.config.clientID),
            URLQueryItem(name: AuthKeys.redirectURI, value: self.config.redirectUri),
            URLQueryItem(name: AuthKeys.responseType, value: self.config.responseType),
            URLQueryItem(name: AuthKeys.codeChallenge, value: codeChallenge),
            URLQueryItem(name: AuthKeys.challengeMethod, value: self.config.challengeMethod)
        ]
        
        // Optional state - SDK will provide by default
        if let state = self.config.state {
            queryItems.append(URLQueryItem(name: AuthKeys.state, value: state))
        }

        // Optional scope
        if let scopes = self.config.scopes {
            queryItems.append(URLQueryItem(name: AuthKeys.scope, value: scopes))
        }
        
        // Additional params
        if let params = self.config.additionalAuthParams {
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }

        components.queryItems = queryItems
        let url = components.url!

        print("Auth Url: \(url)")
        return url
    }
    
    public func createAcessTokenRequest(code: String, codeVerifier: String) -> URLRequest {

        
        let url = URL(string: self.config.tokenUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Headers
        // Form encoded by default
        request.addValue(AuthKeys.contentType, forHTTPHeaderField: AuthValues.formUrlEncoded)
        
        if let headers = self.config.additionalTokenHeaders {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        // Body
        var body = String.empty
        body.append("\(AuthKeys.code)=\(code)")
        
        if let redirectUri = self.config.redirectUri.urlEncoded {
            body.append("&\(AuthKeys.redirectURI)=\(redirectUri)")
        }
        
        body.append("&\(AuthKeys.clientID)=\(self.config.clientID)")
        body.append("&\(AuthKeys.codeVerifier)=\(codeVerifier)")
        body.append("&\(AuthKeys.grantType)=\(AuthValues.authorizationCode)")

        // Additional params
        if let params = self.config.additionalTokenBodyParams {
            for (key, value) in params {
                body.append("&\(key)=\(value)")
            }
        }
            
        request.httpBody = body.urlEncoded?.data(using: .utf8)
        
        print("Token Request: \(request)")
        return request
    }
}
