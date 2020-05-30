//
//  Response 2.0.swift
//  On The Map
//
//  Created by Sergey on 30/12/19.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
class fullLocationResponse {
    struct LocationResponse {
        var response = "results"
        var firstName = "first name"
        var lastName = "last name"
        var latitude = 0.0
        var longitude = 0.0
       static var mapStrings = "mapString"
        var mediaURLs = "media"
        var objectID = "objectID"
        var uniqueKey = "233"
        var updatedAt = "updatedAt"
        var location = "location"
        init() { }
        
        
        init(dictionary: [String: AnyObject]) {
                if let first = dictionary[parametersAll.StudentLocation.firstName] as? String {
                    firstName = first
                }
                if let last = dictionary[parametersAll.StudentLocation.lastName] as? String {
                    lastName = last
                }
                if let objID = dictionary[parametersAll.StudentLocation.objectId] as? String {
                    objectID = objID
                }
                if let uniqKey = dictionary[parametersAll.StudentLocation.uniqueKey] as? String {
                    uniqueKey = uniqKey
                }
                if let mapString = dictionary[parametersAll.StudentLocation.mapString] as? String {
                    LocationResponse.mapStrings = mapString
                }
                if let mediaURL = dictionary[parametersAll.StudentLocation.mediaURL] as? String {
                    mediaURLs = mediaURL
                }
                if let lon = dictionary[parametersAll.StudentLocation.longitude] as? Double {
                    longitude = lon
                }
                if let lat = dictionary[parametersAll.StudentLocation.latitude] as? Double {
                    latitude = lat
                }
            }
            
            static func studentsFromResults(_ results: [[String:AnyObject]]) -> [LocationResponse] {
                
                var students = [LocationResponse]()
                for result in results {
                    students.append(LocationResponse(dictionary: result))
                }
                
                return students
            }
                
        }
        
}
