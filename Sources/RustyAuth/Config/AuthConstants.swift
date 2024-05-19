//
//  AuthConstants.swift
//
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

public struct AuthKeys {
    
    // General
    public static let accessToken = "access_token"
    public static let bearer = "bearer"
    public static let clientID = "client_id"
    public static let challengeMethod = "code_challenge_method"
    public static let code = "code"
    public static let codeChallenge = "code_challenge"
    public static let codeVerifier = "code_verifier"
    public static let contentType = "Content-Type"
    public static let error = "error"
    public static let grantType = "grant_type"
    public static let redirectURI = "redirect_uri"
    public static let responseType = "response_type"
    public static let scope = "scope"
    public static let state = "state"
}

public struct AuthValues {

    public static let formUrlEncoded = "application/x-www-form-urlencoded"
    public static let authorizationCode = "authorization_code"
}

public struct AuthMethods {

    public static let S256 = "S256"
}
