//
//  DecodingError+Extension.swift
//  DailyFeed
//
//  Created by Sumit Paul on 20/06/17.
//  Copyright © 2017 llc. All rights reserved.
//

import Foundation

// Error for unknown case
enum JSONDecodingError: Error, LocalizedError {
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("Unknown Error occured", comment: "")
        }
    }
}

// Extension on Decoding Error to provide better and concise debug description
extension DecodingError {
    
    public var errorDescription: String? {
        switch  self {
        case .dataCorrupted(let context):
            return NSLocalizedString(context.debugDescription, comment: "")
        case .keyNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        case .typeMismatch(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        case .valueNotFound(_, let context):
            return NSLocalizedString("\(context.debugDescription)", comment: "")
        }
    }
}
