//
//  AddLink.swift
//  On The Map
//
//  Created by Sergey on 21/2/20.
//  Copyright © 2020 Sergey. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class addLinks : UIViewController, MKMapViewDelegate {
    @IBOutlet weak var fullMapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMapView()
    }
    @IBAction func cancelButtons(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func populateMapView(){
        
        var annotations = [MKPointAnnotation]()
        let locationResponse = fullLocationResponse.LocationResponse()
        let lat =  CLLocationDegrees(locationResponse.latitude)
        let lon = CLLocationDegrees(locationResponse.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let firstname = parametersAll.StudentLocation.publicfirstName
        let lastname = parametersAll.StudentLocation.publiclastName

        annotation.title = "\(firstname) \(lastname)"
    
        annotation.subtitle = parametersAll.StudentLocation.mediaURL
        annotations.append(annotation)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.5, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        performUIUpdatesOnMain {
            self.fullMapView.addAnnotations(annotations)
            self.fullMapView.setRegion(region, animated: true)
            print("New location added to the Map View.")
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
      taskPostStudentLocation{ (results, error) in
            
            if (error != nil) {
                performUIUpdatesOnMain {
                  
                   self.displayAlert(title: "Error", message: "location could not be submitted")
            }
                print(error as Any)
            } else {
                if let objectId = results {
                    parametersAll.StudentLocation.objectId = objectId
                    self.performSegue(withIdentifier: "mapView", sender: self)
                }
                print("successfully added")
            }
        }
    }
}
