//
//  ViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class Facilities: UIViewController, MKMapViewDelegate{

    var pins = [FacilityPinInfo]()
    @IBOutlet weak var mapView: MKMapView!
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()
    var newFacilityImage: UIImage?
    var zoomChecker = false
    override func viewWillAppear(_ animated: Bool) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
            self.zoomChecker = false
            print("false")
        } else {
            self.zoomChecker = true
            print("true")
            self.retriveInfo()
        }

        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newFacilityImage = self.ResizeImage(image: UIImage(named: "facilityImage")!,targetSize: CGSize(width: 60, height: 80.0))
               mapView.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if self.zoomChecker == true{
            self.zoomToUserLocation()
        }
        locationManager.stopUpdatingLocation()
    }

    func retriveInfo() ->Void{
        let conditionall = ref.child("facilities")
        conditionall.observe(.childAdded, with:  { (snapshot) in
            let m = snapshot.value as? [String: Any]
            // self.retriveSecondKeys(key: snapshot.key)
            for item in m!{
                let n = item.value as? [String: Any]
                if (n?["facilityPhoto"]  != nil){
                    let tempInfo = FacilityPinInfo(passedAddedDate: (n?["addedDate"] as? Double)!, passedAdditionalFacilityInfo: (n?["additionalFacilityInfo"] as? String)!, passedCity: (n?["city"] as? String)!, passedFacilityPhoto: (n?["facilityPhoto"] as? String)!, passedLat: (n?["lat"] as? Double)!, passedLong: (n?["long"] as? Double)!, passedName: (n?["name"] as? String)!, passedState: (n?["state"] as? String)!, passedStreetAddress: (n?["streetAddress"] as? String)!, passedUserIDPostingThis: (n?["userIDPostingThis"] as? String)!, passedZip: (n?["zip"] as? String)!)
                    self.pins.append(tempInfo)
                    self.addMapNotation(tempFacility: tempInfo)
                }
            }
        })
    }
    
    func addMapNotation(tempFacility: FacilityPinInfo) -> Void{
        self.locationManager.startUpdatingLocation()
        let point = MKPointAnnotation()
        let pinLocation = CLLocation(latitude: tempFacility.lat!, longitude: tempFacility.long!)
        point.coordinate.latitude = tempFacility.lat!
        point.coordinate.longitude = tempFacility.long!
        point.title = tempFacility.name
        let distanceInMiles = self.locationManager.location!.distance(from: pinLocation) / 1609.344
        point.subtitle = (String(format: "%.2f", distanceInMiles)) + " " + "miles"

        self.mapView.addAnnotation(point as MKAnnotation)
        self.mapView.reloadInputViews()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            let reuseId = "pin"
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.rightCalloutAccessoryView = UIButton(type: .infoDark)
            anView?.leftCalloutAccessoryView = UIImageView.init(image: self.newFacilityImage)
            anView?.image = UIImage(named: "facilityE")
            anView?.canShowCallout = true
            anView?.isUserInteractionEnabled = true
            return anView
    }
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView {
        let selectedAnnotation = view.annotation
            for item in pins{
                if (item.lat == selectedAnnotation?.coordinate.latitude && item.long == selectedAnnotation?.coordinate.longitude){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "showPinInfoVC") as! ShowPinInfoViewController
                    vc.passedPin = [item]
                    self.mapView.deselectAnnotation(selectedAnnotation, animated: false)
                    self.present(vc, animated: true) {
                    }
    
                }
            }
            }
        }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func zoomToUserLocation(){
        self.mapView.setRegion(MKCoordinateRegionMake((self.locationManager.location?.coordinate)!, MKCoordinateSpanMake(0.6, 0.6)), animated: false)
        self.zoomChecker = false
    }
    
}

