//
//  File 3.0.swift
//  On The Map
//
//  Created by Sergey on 27/12/19.
//  Copyright © 2019 Sergey. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import AddressBookUI
import MapKit
class addLocation: UIViewController, UITextFieldDelegate  {
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterLinkTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var activityView : UIView!
    @IBOutlet weak var activityText: UITextView!
    @IBOutlet weak var findLocationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var findLocationButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addLocationWrapperView: UIView!
    @IBOutlet weak var foundLocationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let animationSpeed = 0.6
    var addLattitude: Double?
    var addLongtitude: Double?
    var address = ""
    var mediaURL = ""
     enum ActionState: Int{
           case findLocationAction = 0
           case addLocationAction = 1
       }
        override func viewDidLoad() {
        super.viewDidLoad()
        ///enterLocationTextField.delegate = self
        ///enterLinkTextField.delegate = self
///        nextButton.isEnabled = true
            ///used to be false
    }
    override func viewWillAppear(_ animated: Bool){
        setup()
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        ///@IBAction func findLocationPressed(_ sender: Any) {
        ///if enterLocationTextField.text!.isEmpty{
                            ///displayAlert(title: "Location Text Field Empty", message: "You must enter your Location")
        ///}else if enterLinkTextField.text!.isEmpty{
                            ///displayAlert(title: "URL Text Field Empty", message: "You must enter a Website")
        ///}else{
            ///address = enterLocationTextField.text!
            ///if address.isEmpty{
                ///showActivity(activityText: "searching location", mapAlpha:false)
                
            ///}
            ///parametersAll.StudentLocation.mapString = enterLocationTextField.text!
            ///parametersAll.StudentLocation.mediaURL = enterLinkTextField.text!
           /// forwardGeocoding(address)
            ///findOnTheMapButton.isEnabled = true
           /// nextButton.isEnabled = true
           ///     }
  ///  }
    
    func forwardGeocoding(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        guard (error == nil) else {
            print("Unable to Forward Geocode Address (\(String(describing: error)))")
                            displayAlert(title: "Geocode Error", message: "Unable to Forward Geocode Address")
            return
        }
        
        if let placemarks = placemarks, placemarks.count > 0 {
            let placemark = placemarks[0]
            if let location = placemark.location {
                let coordinate = location.coordinate
                print("*** coordinate ***")
                print(placemark)
                
                var locationResponse = fullLocationResponse.LocationResponse()
                locationResponse.latitude = coordinate.latitude
                locationResponse.longitude = coordinate.longitude
                print(coordinate.latitude)
                print(coordinate.longitude)
    
                
                if (placemark.locality != nil && placemark.administrativeArea != nil){
                    fullLocationResponse.LocationResponse.mapStrings = ("\(placemark.locality!),\(placemark.administrativeArea!)")
                }
                getUserName()
            } else {
                print("error")
                displayAlert(title: "User Data", message: "No Matching Location Found")
            }
        }
    }
    func getUserName()   {
        taskgetPublicUserData {(success, errorString) in
            guard (errorString == nil) else{
                
                performUIUpdatesOnMain {
                                        self.displayAlert(title: "User Data", message: errorString)
                }
                return
            }
        }
    }
    func showActivity(activityText: String, mapAlpha: Bool){
        self.activityText.text = activityText
        spinner.startAnimating()
        self.activityView.alpha = 1
    }
    func hideActivity(){
        spinner.stopAnimating()
        self.activityView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.activityView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
        @IBAction func printNames(_ sender: Any) {
        var name = userNames.Users()
        name.firstName = parametersAll.StudentLocation.publicfirstName
        name.lastName = parametersAll.StudentLocation.publiclastName
        print(name.firstName)
        print(name.lastName)
        presentSubmitLocationView()
    }
        private func presentSubmitLocationView(){
        performSegue(withIdentifier: "submitNewLocation", sender: self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
func getGeoCoordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
let geocoder = CLGeocoder()
geocoder.geocodeAddressString(address) {
    (placemarks, error) in
    guard error == nil else {
        print("Geocoding error: \(error!)")
        completion(nil, error)
        return
    }
    completion(placemarks?.first?.location?.coordinate, nil)
    }
}
extension addLocation{
    ///var addLatitude: Double?
    ///var addLongtitude: Double?
func requestHandlerPostLocation(location: CLLocationCoordinate2D?, error: Error?){
    guard let location = location else{
        displayAlert(title: "GeoLocation Error", message: "Could not find location On The Map" )
        return
    }
}
    func setup(){
        hideActivity()
         findOnTheMapButton.tag = 0
         self.tabBarController?.tabBar.isHidden = true
               
               
               enterLocationTextField.layer.cornerRadius = Utilities.cornerRadius
               enterLinkTextField.layer.cornerRadius = Utilities.cornerRadius
               findOnTheMapButton.layer.cornerRadius = Utilities.cornerRadius
               nextButton.layer.cornerRadius = Utilities.cornerRadius
               foundLocationLabel.text = ""
               activityView.layer.cornerRadius = 10
        
    }
    
    func createAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        annotation.title = ""
        annotation.subtitle = ""
        
        self.mapView.addAnnotation(annotation)
    }
    func requestHandlerGeoLocation(location: CLLocationCoordinate2D?, error: Error?){
    guard let location = location else{
        displayAlert(title: "GeoLocation Error", message: "\(CustomError.locationNotFound.errorDescription!)" )
        return
    }
    self.addLattitude = location.latitude
    self.addLongtitude = location.longitude
    createAnnotation(location: location)
    let coordinateRegion = Utilities.centerMapOnLocation(distance: 250000, latitude: location.latitude, longitude: location.longitude)
    self.mapView.setRegion(coordinateRegion, animated: true)
    hideActivity()
    setActionState(state: .addLocationAction)
}

func setActionState(state: ActionState){
       switch state{
       case .findLocationAction:
           findOnTheMapButton.tag = ActionState.findLocationAction.rawValue
           animate(state: ActionState.findLocationAction)
       case .addLocationAction:
           findOnTheMapButton.tag = ActionState.addLocationAction.rawValue
           foundLocationLabel.text = "Location found: \(enterLinkTextField.text!)"
           ///animate(state: ActionState.addLocationAction)
       }
   }
    func animate(state: ActionState){
       switch state{
       case .addLocationAction:
///           self.findLocationTopConstraint.constant = -155
        ///   self.findLocationButtonTopConstraint.constant = 25
           UIView.animate(withDuration: 0.5, animations: {
               self.findOnTheMapButton.alpha = 0
               self.enterLinkTextField.alpha = 0
               self.addLocationWrapperView.alpha = 1
               self.view.layoutIfNeeded()
           },  completion: { (finish) in
               UIView.animate(withDuration: 0.8, animations: {
                   self.findOnTheMapButton.setTitle("Find New Location", for: .normal)
                   self.findOnTheMapButton.alpha = 0.5
               })
           })
       case .findLocationAction:
///           self.findLocationTopConstraint.constant = 5
       ///    self.findLocationButtonTopConstraint.constant = 10
           UIView.animate(withDuration: 0.5, animations: {
               self.enterLocationTextField.alpha = 1
               self.findOnTheMapButton.alpha = 1
               self.addLocationWrapperView.alpha = 0
            self.view.layoutIfNeeded()
           })
       }
   }
func segueBackAfterAddLocationSuccess(){
guard let navigationCount = self.navigationController?.viewControllers.count else { return }
if let mapVC = self.navigationController!.viewControllers[navigationCount-2] as? viewController{
    mapVC.addedLocation = CLLocationCoordinate2D(latitude: addLattitude ?? 0, longitude: addLongtitude ?? 0)
    mapVC.seagueFromAddLocationSuccess = true
    self.navigationController?.popToViewController(mapVC, animated: true)
}
      func requestHandlerPostLocation(postLocation: CLLocationCoordinate2D?, error: Error?){
            guard postLocation != nil else{
              displayAlert(title: "Location Post Failed", message: CustomError.postLocationFailed.errorDescription!)
              return
          }
          
          self.activityText.text = "Post Location Successful"
          self.spinner.stopAnimating()
          segueBackAfterAddLocationSuccess()

      }
      }    }
    //////////////////////////////////////////////////////////extensions
extension addLocation{
     @IBAction func addLocationButtonTapped(_ sender: Any) {
           if !Utilities.verifyUrl(urlString: enterLinkTextField.text){
               displayAlert(title: "Website Check", message: "Please Check Your Website name!")
           }
            else {
                forwardGeocoding(address)
            }
               return
           }
        func getGeoCoordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) {
                (placemarks, error) in
                guard error == nil else {
                    print("Geocoding error: \(error!)")
                    completion(nil, error)
                    return
                }
                completion(placemarks?.first?.location?.coordinate, nil)
            }
        }
            }        
extension addLocation{
    
@IBAction func findLocationButtonTapped(_ sender: Any) {
    switch findOnTheMapButton.tag{
        case 0:
            if let address = enterLocationTextField.text, !address.isEmpty {
                showActivity(activityText: "searching location", mapAlpha: false)
                getGeoCoordinates(forAddress: address, completion: requestHandlerGeoLocation(location:error:))
            } else {
               displayAlert(title: "No Location Text", message: "No Location Text")
        }
        case 1:
            setActionState(state: .findLocationAction)
        default:
            print("do nothing")
    }
    self.view.endEditing(true)
           }
       }
