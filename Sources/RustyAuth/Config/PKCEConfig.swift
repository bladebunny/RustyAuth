//
//  PKCEConfig.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation
import RustyExtensions

public protocol PKCEConfig {

    // Urls
    var authorizeUrl: String { get }
    var tokenUrl: String { get }
    var redirectUri: String { get }

    // Params
    var clientID: String { get }
    var scheme: String { get }
    var responseType: String { get }
    var challengeMethod: String { get }
    var state: String? { get }
    var additionalAuthParams: [String: String]? { get }
    var additionalTokenBodyParams: [String: String]? { get }
    var additionalTokenHeaders: [String: String]? { get }
}

public class StandardPKCEConfig: PKCEConfig {

    // MARK: - Properties
    // Urls
    public let authorizeUrl: String
    public let tokenUrl: String
    public let redirectUri: String

    // Params
    public let clientID: String
    public let scheme: String
    public var responseType: String
    public var challengeMethod: String
    public var state: String?
    public var additionalAuthParams: [String: String]?
    public var additionalTokenBodyParams: [String: String]?
    public var additionalTokenHeaders: [String: String]?

    // MARK: - Init
    public init(authorizeUrl: String,
                tokenUrl: String,
                clientID: String,
                responseType: String = AuthKeys.code,
                redirectUri: String = String.empty,
                scheme: String,
                challengeMethod: String = AuthMethods.S256,
                state: String? = UUID().uuidString) {
        
        self.authorizeUrl = authorizeUrl
        self.challengeMethod = challengeMethod
        self.clientID = clientID
        self.redirectUri = redirectUri
        self.responseType = responseType
        self.scheme = scheme
        self.tokenUrl = tokenUrl
        self.state = state
    }
}
