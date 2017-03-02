//
//  PermissionsViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/2/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit

class PermissionsViewController: UIViewController {
    let permissionAssistant = SPRequestPermissionAssistant.modules.dialog.interactive.create(with: [.Camera, .PhotoLibrary, .Notification])

    @IBOutlet weak var patternView: SPPatternView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
