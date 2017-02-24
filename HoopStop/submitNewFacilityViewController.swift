//
//  submitNewFacilityViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import MapKit

class submitNewFacilityViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,MKMapViewDelegate {
    @IBOutlet weak var facilityName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addPhotoImage: UIImageView!
    @IBOutlet weak var additionalFacilityInfo: UITextView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        additionalFacilityInfo.delegate = self
        if (CLLocationManager.locationServicesEnabled()){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setAddress()
        }else{
            #if debug
                println("Location services are not enabled");
            #endif
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        additionalFacilityInfo.text = nil
        additionalFacilityInfo.textColor = UIColor.black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setAddress(){
        locationManager.startUpdatingLocation()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Address dictionary
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.facilityName.text = locationName as String
            }
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                self.streetAddress.text = street as String
            }
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.city.text = city as String
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                self.zip.text = zip as String
            }
            // state
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                self.state.text = state as String
            }
            // Country
            //if let country = placeMark.addressDictionary!["Country"] as? NSString {
            //}
        })
        self.locationManager.stopUpdatingLocation()
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
            self.facilityName.text = nil
            self.streetAddress.text = nil
            self.city.text = nil
            self.zip.text = nil
            self.state.text = nil
            additionalFacilityInfo.text = nil
    }
    @IBAction func thisLocationButtonPressed(_ sender: Any) {
        setAddress()
    }
}


