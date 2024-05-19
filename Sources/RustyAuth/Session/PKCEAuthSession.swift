//
//  PKCEAuthSession.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation
import Combine
import AuthenticationServices

public enum AuthSessionState {
    case idle
    case authenticating
    case accessCodeReceived(code: String, state: String?)
    case authenticated(token: String)
    case error(Error)
    case failed(Error?)
    case cancelled
}

public class PKCEAuthSession: NSObject, ObservableObject {
    
    // MARK: - Properties
    let urlBuilder: URLBuilder
    let config: PKCEConfig
    let presentationAnchor: ASPresentationAnchor
    var session: ASWebAuthenticationSession? = nil
    var codeVerifier: String = String.empty
    var cancellables: Set<AnyCancellable> = Set()
    
    @Published public var state: AuthSessionState = .idle
    
    // MARK: - Initializers
    public init(config: PKCEConfig, presentationAnchor: ASPresentationAnchor) {
        
        self.config = config
        self.urlBuilder = URLBuilder(config: config)
        self.presentationAnchor = presentationAnchor
    }
    
    deinit {
        self.cancel()
        self.state = .idle
    }
    
    // MARK: - Auth actions
    public func start() {
        
        let verifier = PKCE.createCodeVerifier()
        let challenge = PKCE.createCodeChallenge(from: verifier)!
        let url = self.urlBuilder.createAuthURL(codeChallenge: challenge)
        
        let session = ASWebAuthenticationSession(url: url,
                                                 callbackURLScheme: self.config.scheme,
                                                 completionHandler: self.authHandler)
        
        session.presentationContextProvider = self
        
        self.state = .authenticating
        self.codeVerifier = verifier
        self.session = session

        session.start()
    }
    
    public func cancel() {
        self.session?.cancel()
        self.state = .cancelled
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
        
        self.cancellables.removeAll()
    }
    
    public func reset() {
        self.state = .idle
    }
    
    // MARK: - Auth handlers
    private func authHandler(_ callbackURL: URL?, error: Error? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return}
            
            guard let url = callbackURL else {
                
                // Convert error if possible
                var resultError = error
                if let error = error {
                    resultError = AuthError.authRequestFailed(error)
                }
                
                self.state = .failed(resultError)
                return
            }
            
            if let error = error {
                self.state = .error(error)
                return
            }
            
            let items = URLComponents(string: url.absoluteString)?.queryItems
            guard let code = items?.filter({ $0.name == AuthKeys.code }).first?.value else {
                
                self.state = .failed(AuthError.authResponseNoCode)
                
                return
            }
            
            // Get code
            self.state = .accessCodeReceived(code: code, state: items?.filter({ $0.name == AuthKeys.code }).first?.value)
            self.exchangeForToken(code: code)
        }
    }
    
    private func exchangeForToken(code: String) {
        
        let request = self.urlBuilder.createAcessTokenRequest(code: code,
                                                              codeVerifier: self.codeVerifier)
        print("Request: \(request.debugDescription)")
        
        URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                print(result)
            }, receiveValue: { data, response in
                
                guard let response = response as? HTTPURLResponse else {
                    self.state = .failed(URLError(.badServerResponse))
                    return
                }
                
                guard response.statusCode == 200, let body = String(data: data, encoding: .utf8) else {
                    self.state = .failed(URLError(.cannotDecodeRawData))
                    return
                }
                
//                let parameters: [String: String] = body.components(separatedBy: "&")
//                    .reduce(into: [:]) { dict, value in
//                        let keyValuePair = value.components(separatedBy: "=")
//                        dict[keyValuePair.first!] = keyValuePair.last!
//                    }
                
//                let token = AccessToken(token: body)
                
                self.state = .authenticated(token: body)
                self.codeVerifier = String.empty
            })
            .store(in: &self.cancellables)
    }
}

extension PKCEAuthSession: ASWebAuthenticationPresentationContextProviding {
    
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.presentationAnchor
    }
}
