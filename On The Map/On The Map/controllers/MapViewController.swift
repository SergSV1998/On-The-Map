//
//  MapViewController.swift
//  On The Map
//
//  Created by Sergey on 29/12/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class viewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
     var addedLocation: CLLocationCoordinate2D?
    var seagueFromAddLocationSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getUserInfo()
    }
    func getUserInfo() {
        
        taskGetStudentLocations { (studentInfo, error) in
            if let studentInfo = studentInfo {
                parametersAll.StudentLocation.studentsLocDict = studentInfo
                performUIUpdatesOnMain {
                    ///self.populateMapView()
                }
            } else {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Invalid URL", message: "Unable to get student locations.")
                }
                print(error as Any)
            }
        }
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        logout { (success, errorString) in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated:true,completion:nil)
                }
            } else {
                print(errorString as Any)
                
                self.displayAlert(title: "Error", message: "Logout was unsuccessful")
            }
        }
        
    }
     func checkIfSeagueFromAddedLocation(success: Bool){
             if success{
                 if let latitude = addedLocation?.latitude, let longitude = addedLocation?.longitude{
                     let coordinateRegion = Utilities.centerMapOnLocation(distance: 3000000, latitude: latitude, longitude: longitude)
                     self.mapView.setRegion(coordinateRegion, animated: true)
                 }
                 seagueFromAddLocationSuccess = false
             }
        func populateMapView(){
        var annotations = [MKPointAnnotation]()
        for student in parametersAll.StudentLocation.studentsLocDict{
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = "\(student.mediaURLs)"
            annotations.append(annotation)
            
        }
        self.mapView.addAnnotations(annotations)
        print("Annotations are now added to the Map View.")
    }
    
    func checkIfSeagueFromAddedLocation(success: Bool){
        if success{
            if let latitude = addedLocation?.latitude, let longitude = addedLocation?.longitude{
                let coordinateRegion = Utilities.centerMapOnLocation(distance: 3000000, latitude: latitude, longitude: longitude)
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
            seagueFromAddLocationSuccess = false
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.shared
            if let annotation = view.annotation, let urlString = annotation.subtitle {
                if let url = URL(string: urlString!) {
                    if app.canOpenURL(url) {
                        app.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        //                            displayAlert(title: "Invalid URL", message: "Selected URL is not available")
                    }
                } else {
                    //                        displayAlert(title: "Invalid URL", message: "Not available URL")
                }
            }
        }
    }
}
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
}



