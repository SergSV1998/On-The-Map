//
//  Utilitiea.swift
//  On The Map
//
//  Created by Sergey on 13/5/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class Utilities{
    static let cornerRadius = CGFloat(2.0)
    
    class func centerMapOnLocation(distance: Double, latitude: Double, longitude: Double) -> MKCoordinateRegion {
        let regionRadius: CLLocationDistance = distance
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        return coordinateRegion
    }
    
    class func verifyUrl(urlString: String?) -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        guard let urlString = urlString else{
            print("verify website, no url")
            return false
        }

        if let match = detector.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.endIndex.encodedOffset)) {
            return match.range.length == urlString.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    class func addHttp(urlString: String) -> URL?{
        guard URL(string: urlString) != nil else{
            return nil
        }
        
        if urlString.hasPrefix("https://") || urlString.hasPrefix("http://"){
            let url = URL(string: urlString)
            return url
        }else {
            let correctedURL = "http://\(urlString)"
            let url = URL(string: correctedURL)
            return url
        }
    }
    
    class func openUrl(urlString: String, completion: @escaping (Bool) -> Void){
        if !Utilities.verifyUrl(urlString: urlString){
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        if let urlHttp = Utilities.addHttp(urlString: urlString){
            UIApplication.shared.open(urlHttp, options: [:], completionHandler: {(success) in
                if success{
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }else{
                    DispatchQueue.main.async {
                    completion(false)
                    }
                }
            })
        } else{
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}
