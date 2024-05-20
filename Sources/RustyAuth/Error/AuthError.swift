//
//  File.swift
//  
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

public enum AuthError: LocalizedError {
    case authRequestFailed(Error)
    case authResponseInvalidState
    case authResponseNoCode
    case authResponseNoState
    case authResponseNoUrl
    case tokenRequestFailed(Error)
    case tokenRequestServerError(String)
    case tokenResponseInvalidData(String)
    case tokenResponseNoData
    
    public var localizedDescription: String {
        switch self {

        case .authRequestFailed(let error):
            return "Authorization request failed: \(error.localizedDescription)"
        case .authResponseInvalidState:
            return "Authorization response state does not match!!"
        case .authResponseNoUrl:
            return "Authorization response data does not include a valide url"
        case .authResponseNoCode:
            return "Authorization response data does not include a code"
        case .authResponseNoState:
            return "Authorization response data does not include a verification state"
        case .tokenRequestFailed(let error):
            return "Token request failed: \(error.localizedDescription)"
        case .tokenRequestServerError(let status):
            return "Authorization request failed with http status: \(status)"
        case .tokenResponseNoData:
            return "Token response contains no data"
        case .tokenResponseInvalidData(let reason):
            return "Invalid data received from token response: \(reason)"
        }
    }
}
