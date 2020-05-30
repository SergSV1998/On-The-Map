//
//  parseSessionResponse.swift
//  On The Map
//
//  Created by Sergey on 12/5/20.
//  Copyright © 2020 Sergey. All rights reserved.
//

import Foundation

struct ParseErrorResponse: Codable{
    let code: Int
    let error: String
}

extension ParseErrorResponse: LocalizedError{
    var errorDescription: String? {
        return error
    }
}
