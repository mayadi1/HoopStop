//
//  LoginViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loading")
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    SVProgressHUD.dismiss()
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                return
            }else{
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Login Success!")
                self.dismiss(animated: false) {
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
}
