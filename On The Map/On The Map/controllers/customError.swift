//
//  customError.swift
//  On The Map
//
//  Created by Sergey on 15/5/20.
//  Copyright © 2020 Sergey. All rights reserved.
//

import Foundation
enum CustomError: Error{
    case decodeFailed
    case noResponseData
    case noWebsite
    case locationNotFound
    case urlNotValid
    case postLocationFailed
    case findAddressTextEmpty
}
extension CustomError: LocalizedError{
    var errorDescription: String?{
        switch self{
        case .decodeFailed:
            return "Decoding of response data failed"
        case .noResponseData:
            return "No response data from request"
        case .noWebsite:
            return "Please check the provided website URL. (http://)"
        case .locationNotFound:
            return "Location could not be found"
        case .urlNotValid:
            return "Unable to open URL"
        case .postLocationFailed:
            return "Posting of location failed"
        case .findAddressTextEmpty:
            return "Pleaase provide an address or location"
        }
    }
}
