//
//  TaskListHelpers.swift
//  On The Map
//
//  Created by Sergey on 21/2/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation
class taskslisthelpers {
    
    var session = URLSession.shared
    static let apiKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"   ///"AIzaSyD5Kbkg0HjrOqgsfOIm9lvd33v-RvwOV58"
    ///  ///"e2072a33-298a-413f-b2a4-99f5cfd89185"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
}


func taskPostASessionAuth ( username:String, password:String, _completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    let urlString = parametersAll.Constants.sessionURL
    let headerFields = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
    let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
    
    let task = Client.taskForPOSTMethods(urlString: urlString, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
        
        if let error = error {
            
            _completionHandlerForAuth(false, error.localizedDescription)
        } else {
            if let account = results?[parametersAll.PostParameter.Account] as? NSDictionary {
                if let accountKey = account[parametersAll.PostParameter.key] as?
                    
                    String{
                    postASessionResponse.SessionResponse.accountKey = accountKey
                    _completionHandlerForAuth(true, nil)
                    print("login successful")
                }
                
            } else {
                print("Could not find \(parametersAll.PostParameter.key) in \(String(describing: results))")
                _completionHandlerForAuth(false, "Invalid Credentials")
                
            }
        }
    }
    
    task.resume()
    
    
}

func taskGetStudentLocations (_ completionHandlerForGETStudentLocation: @escaping ( _ result: [fullLocationResponse.LocationResponse]?, _ error: NSError?) -> Void) {
    let parametersForMethod = [
        parametersAll.GetParameter.limit : 100,
        parametersAll.GetParameter.order : "-updatedAt"
        ] as [String : Any]
    
    let requestURL = parametersAll.Constants.studentLocationURL + parametersAll.escapedParameters (parametersForMethod as [String:AnyObject])
    
    let error = Client.taskForGETMethod (urlString:requestURL) { (results, error) in
        
        if let error = error {
            
            completionHandlerForGETStudentLocation(nil, error)
        } else {
            if let results = results?[parametersAll.StudentLocation.Response] as? [[String:AnyObject]] {
                let studentInfo = fullLocationResponse.LocationResponse.studentsFromResults(results)
                completionHandlerForGETStudentLocation(studentInfo, nil)
            } else {
                completionHandlerForGETStudentLocation(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocation"]))
            }
        }
    }
    
}

func taskPostStudentLocation(_ completionHandlerForPostStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
    let requestURL = parametersAll.Constants.studentLocationURL

    let jsonBody = "{\"uniqueKey\": \"\(parametersAll.StudentLocation.uniqueKey)\", \"firstName\": \"\(parametersAll.StudentLocation.firstName)\", \"lastName\": \"\(parametersAll.StudentLocation.lastName)\",\"mapString\": \"\(parametersAll.StudentLocation.mapString)\", \"mediaURL\": \"\(parametersAll.StudentLocation.mediaURL)\",\"latitude\":\(parametersAll.StudentLocation.latitude), \"longitude\": \(parametersAll.StudentLocation.longitude)}"
    print(jsonBody)
    
    let headerFields = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
    let task = Client.taskForPOSTMethod (urlString:requestURL, headerFields: headerFields, jsonBody: jsonBody) { (results, error) in
        
        if let error = error {
            completionHandlerForPostStudentLocation(nil, error)
        } else {
            if let objectId = results?[postLocationResponse.postLocationResponse.objectId] as? String {
                completionHandlerForPostStudentLocation(objectId, nil)
            } else {
                print(completionHandlerForPostStudentLocation(nil, NSError(domain: "postNewStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"])))
            }
        }
        
    }
    
    task.resume()
}

func taskDeleteASession (){
    
    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { 
            return
        }
    }
    task.resume()
    
}

func taskgetPublicUserData (_ completionHandlerForUserData: @escaping (_ result:AnyObject?, _ errorString: String?) -> Void) {
    
    let urlString = parametersAll.Constants.userURL + "/\(postASessionResponse.SessionResponse.accountKey)"
    let task = Client.taskForGETMethods(urlString: urlString) { (results, error) in
        if let error = error {
            print(error.localizedDescription)
            completionHandlerForUserData(nil, "There was an error getting user data.")
        }
        else {
            
            if let last_name = results?[parametersAll.StudentLocation.publiclastName] as? String,
                let first_name = results?[parametersAll.StudentLocation.publicfirstName] as? String{
                parametersAll.StudentLocation.publiclastName = last_name
                parametersAll.StudentLocation.publicfirstName = first_name
                let user = parametersAll.User(firstName: first_name, lastName: last_name)
                completionHandlerForUserData (user as AnyObject, nil)
            }
                
            else  {
                print("Could not find \(parametersAll.StudentLocation.user) in \(String(describing: results))")
                completionHandlerForUserData(nil,"Could not get the user data.")
                print(postASessionResponse.SessionResponse.accountKey)
            }
        }
    }
    task.resume()
}

func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
    let urlString = parametersAll.Constants.userURL
    
    let request = NSMutableURLRequest(url:URL(string:urlString)!)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies!
        
    {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }
    
    let error = Client.taskForDELETEMethod (request as URLRequest) { (results, error) in
        
        if let error = error {
            print(error.localizedDescription)
            completionHandlerForLogout(false, "There was an error with logout.")
        } else {
        
                completionHandlerForLogout(true, nil)
            print("logged out")
                                               
        }
    }
}
