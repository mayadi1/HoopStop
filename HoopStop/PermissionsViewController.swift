//
//  PermissionsViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/2/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import MapKit

class PermissionsViewController: UIViewController, SPRequestPermissionEventsDelegate {
    public func didSelectedPermission(permission: SPRequestPermissionType) {
        
    }

    public func didAllowPermission(permission: SPRequestPermissionType) {
        self.locationManager.requestWhenInUseAuthorization()
    }

    public func didDeniedPermission(permission: SPRequestPermissionType) {
        
    }

    public func didHide() {
        self.buttonObj.sendActions(for: .touchUpInside)
    }

    let locationManager = CLLocationManager()

    @IBOutlet weak var buttonObj: UIButton!
    var permissionAssistant = SPRequestPermissionAssistant.modules.dialog.interactive.create(with: [.Camera, .PhotoLibrary, .Notification])

    @IBOutlet weak var patternView: SPPatternView!
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionAssistant.eventsDelegate = self
        self.view.backgroundColor = UIColor.init(hex: "#00A3E8")
        self.patternView.setRhombusPattern()
        self.patternView.color = UIColor.white
        self.patternView.alpha = 0.1
        self.patternView.cellWidthMax = 70
        
        DispatchQueue.main.async {
            self.permissionAssistant.present(on: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
