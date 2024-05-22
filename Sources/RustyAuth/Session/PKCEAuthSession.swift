//
//  PKCEAuthSession.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation
import AuthenticationServices


public class PKCEAuthSession: NSObject {
    
    // MARK: - Properties
    let urlBuilder: URLServices
    let config: PKCEConfig
    var session: ASWebAuthenticationSession? = nil
    var codeVerifier: String = String.empty
    
    // MARK: - Initializers
    public init(config: PKCEConfig) {
        
        self.config = config
        self.urlBuilder = URLServices(config: config)
    }
        
    // MARK: - Auth actions
    public func fetchToken(with code: String) async throws -> String {
        
        let request = self.urlBuilder.createAcessTokenRequest(code: code, codeVerifier: self.codeVerifier)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // URL Response check
        guard let urlResponse = response as? HTTPURLResponse else {
            throw AuthError.tokenRequestFailed(URLError(.unknown))
        }
        
        // Success status
        guard urlResponse.statusCode == 200 else {
            throw AuthError.tokenRequestServerError("\(urlResponse.statusCode)")
        }
                
        // Data valid
        guard let result = String(data: data, encoding: .utf8) else {
            throw AuthError.tokenResponseInvalidData("Unable to de-serialize data")
        }
        
        return result
    }
    
    // On MainActor due to UI interaction
    @MainActor public func fetchAuthCode() async throws -> String {
        
        self.codeVerifier = PKCE.createCodeVerifier()
        let challenge = PKCE.createCodeChallenge(from: self.codeVerifier)!
        let url = self.urlBuilder.createAuthURL(codeChallenge: challenge)

        return try await withCheckedThrowingContinuation { (it: CheckedContinuation<String, Error>) -> Void in

            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: self.config.scheme) { url, error in
             
                if let error = error {
                    return it.resume(throwing: error)
                }

                guard let url = url else {
                    return it.resume(throwing: AuthError.authResponseNoUrl)
                }

                // Get state
                guard let items = URLComponents(string: url.absoluteString)?.queryItems,
                      let verifyState = (items.filter({ $0.name == AuthKeys.state }).first?.value as? String) else {
                    return it.resume(throwing: AuthError.authResponseNoState)
                }

                // Verify state
                if let originalState = self.config.state, originalState != verifyState {
                    return it.resume(throwing: AuthError.authResponseInvalidState)
                }

                // Get code
                guard let items = URLComponents(string: url.absoluteString)?.queryItems,
                      let code = items.filter({ $0.name == AuthKeys.code }).first?.value else {
                    return it.resume(throwing: AuthError.authResponseNoCode)
                }
                                    
                it.resume(returning: code)
            }
            
            // Kick it off
            session.presentationContextProvider = self
            session.start()
        }
    }
}

extension PKCEAuthSession: ASWebAuthenticationPresentationContextProviding {
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
