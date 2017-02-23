//
//  ProfileViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    var segueChecker = true
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.loginButton.setTitle("Sign Out", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitNewFacilityButtonPressed(_ sender: Any) {
        //(FIRAuth.auth()?.currentUser?.uid)!
        let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if (loginButton.titleLabel?.text == "Login"){
            segueChecker = true
        }
        else{
            segueChecker = false
            try! FIRAuth.auth()!.signOut()
            self.loginButton.setTitle("Login", for: .normal)
        }
    }
    
     func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "login"){
            if segueChecker == false {
                return false
            }else {
                return true
            }
        }else{
            return true
        }
    }
}
