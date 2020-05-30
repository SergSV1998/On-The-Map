//
//  Parameters.swift
//  On The Map
//
//  Created by Sergey on 21/2/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation

class parametersAll {
    struct Constants {
        static let studentLocationURL =  "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let sessionURL = "https://onthemap-api.udacity.com/v1/session"
        static let userURL = "https://onthemap-api.udacity.com/v1/users"
    }
    struct GetParameter {
        static let limit = "limit"
        //: https://onthemap-api.udacity.com/v1/StudentLocation?limit=100
        static let skip = "skip"
        //: https://onthemap-api.udacity.com/v1/StudentLocation?limit=200&skip=400
        static let order = "order"
        //: https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt
       static var uniqueKey = "uniquekey"
        // https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=1234
       static var userID = "userID "
    }
    
    struct PutParameter {
       static var objectId = "objectID"
        //: https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8
    }
    
    struct PostParameter {
        
        static var udacity = "udacity"
        static var username = "username"
        static var password = "password"
        static var Account = "account"
        static var key = "key"
        static var userid = "id"
        static var expiration = "expiration"
        
    }
    struct StudentLocation {
         static var firstName = "firstName"
        static var lastName = "lastName"
        static var Response = "results"
        static var objectId = "objectId"
        static var uniqueKey = "uniqueKey"
        static var mapString = "mapString"
        static var mediaURL = "mediaURL"
        static var latitude = "latitude"
        static var longitude = "longitude"
        static var createdAt = "createdAt"
        static var updatedAt = "updatedAt"
        static var studentsLocDict = [fullLocationResponse.LocationResponse]()
        static var user = "user"
        static var publicfirstName = "first_name"
        static var publiclastName = "last_name"
    }
    
    struct User{
        var firstName =  "firstName"
        var lastName = "lastName"
        
        }
   
    
    static func escapedParameters(_ parameters: [String:AnyObject]) -> String {
          
          if parameters.isEmpty {
              return ""
          } else {
              var keyValuePairs = [String]()
              
              for (key, value) in parameters {
                  let stringValue = "\(value)"
                  let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                  keyValuePairs.append(key + "=" + "\(escapedValue!)")
                  
              }
              
              return "?\(keyValuePairs.joined(separator: "&"))"
          }
        
      }
    
    class func sharedInstance() -> parametersAll {
           struct Singleton {
               static var sharedInstance = parametersAll()
           }
           return Singleton.sharedInstance
       }
}
