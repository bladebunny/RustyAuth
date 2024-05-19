//
//  File.swift
//  
//
//  Created by Tim Brooks on 5/18/24.
//

import Foundation

public enum AuthError: LocalizedError {
    case authRequestFailed(Error)
    case authResponseNoUrl
    case authResponseNoCode
    case tokenRequestFailed(Error)
    case tokenResponseNoData
    case tokenResponseInvalidData(String)
    
    public var localizedDescription: String {
        switch self {

        case .authRequestFailed(let error):
            return "Authorization request failed: \(error.localizedDescription)"
        case .authResponseNoUrl:
            return "Authorization response data does not include a url"
        case .authResponseNoCode:
            return "Authorization response data does not include a code"
        case .tokenRequestFailed(let error):
            return "Token request failed: \(error.localizedDescription)"
        case .tokenResponseNoData:
            return "Token response contains no data"
        case .tokenResponseInvalidData(let reason):
            return "Invalid data received from token response: \(reason)"
        }
    }
}
