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

class Facilities: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    let ref = FIRDatabase.database().reference()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //Zoom to user Location
        self.mapView.setRegion(MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.6, 0.6)), animated: true)
            locationManager.stopUpdatingLocation()
    }
    
}

