//
//  ProfileViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                DispatchQueue.main.async {() -> Void in
                    self.loginButton.setTitle("Sign Out", for: .normal)
                }
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
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginVC")
            self.present(logInViewController, animated: false, completion: nil)
        }
        else{
            try! FIRAuth.auth()!.signOut()
            SVProgressHUD.showSuccess(withStatus: "Signed out Success!")
            DispatchQueue.main.async {() -> Void in
                self.loginButton.setTitle("Login", for: .normal)
            }
        }
    }
}
