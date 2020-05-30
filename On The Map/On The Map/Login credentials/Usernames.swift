//
//  Response 8.0.swift
//  On The Map
//
//  Created by Sergey on 30/12/19.
//  Copyright © 2019 Sergey. All rights reserved.
//
import Foundation

class userNames {
    struct Users {
        var response = "results"
        var firstName = "first name"
        var lastName = "last name"
        
        init() { }
        
        init(dictionary: [String: AnyObject]) {
                if let first = dictionary[parametersAll.StudentLocation.publiclastName] as? String {
                    firstName = first
                }
                if let last = dictionary[parametersAll.StudentLocation.publiclastName] as? String {
                    lastName = last
                }
            }
            
            static func userNameFromResults(_ results: [[String:AnyObject]]) -> [Users] {
                
                var userNames = [Users]()
                for result in results {
                    userNames.append(Users(dictionary: result))
                }
                
                return userNames
            }
                
        }
        
}
