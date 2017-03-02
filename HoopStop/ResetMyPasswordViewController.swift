//
//  ResetMyPasswordViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/1/15.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase

class ResetMyPasswordViewController: UIViewController {
    @IBOutlet weak var email: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.email.text!) { error in
            if error == nil {
                print("success")
                     let alertController = UIAlertController(title: nil, message: "Reset email sent", preferredStyle: .alert)
                     let OKAction = UIAlertAction(title: "Login", style: .default) { (action) in
                        self.dismiss(animated: true, completion: { 
                        })
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: false){
                    }
            } else {
                print("Error email not sent")
                    let alertController = UIAlertController(title: nil, message: "No email user found", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: false){
                    }
            }
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) { 
        }
    }
}
