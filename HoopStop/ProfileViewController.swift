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
import MessageUI
import Social
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
import MessageUI
import Social

class ProfileViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        self.isEditing = false
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.editProfileButton.isHidden = false
                DispatchQueue.main.async {() -> Void in
                    self.loginButton.setTitle("Sign Out", for: .normal)
                    self.editProfileButton.isHidden = false
                    self.signUpBtn.isHidden = true
                }
            }else{
                self.editProfileButton.isHidden = true
                self.signUpBtn.isHidden = false
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
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let submitNewFacilityViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "submitNewFacilityVC")
                self.present(submitNewFacilityViewController, animated: false, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Membership Required", message: "Membership is required for some of the services. Sign-up/Sign-in in order to access this feature.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
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
    
    @IBAction func singUpButtonPressed(_ sender: Any) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                let alertController = UIAlertController(title: nil, message: "You should sign out first. Thank you!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }else{
                let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let signUpViewController: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "signUpVC")
                self.present(signUpViewController, animated: false, completion: nil)
            }
        }
    }
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
    @IBAction func emailButtonPressed(_ sender: Any) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }else{
            self.sendEmail()}
    }
    @IBAction func facebookButtonPressed(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(UIImage(named: "appSmallIcon"))
        vc?.add(URL(string: "http://www.hoopstop.net"))
        vc?.setInitialText("Have you used HoopStop yet?")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func twitterButtonPressed(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        vc?.add(UIImage(named: "appSmallIcon"))
        vc?.add(URL(string: "http://www.hoopstop.net"))
        vc?.setInitialText("Have you used HoopStop yet?")
        self.present(vc!, animated: true, completion: nil)
    }
    
    //Tanoi has modified this IBAction function
    @IBAction func aboutButtonPressed(_ sender: Any)
    {
        //Tanoi commented this out
        //        UIApplication.shared.openURL(NSURL(string: "http://www.hoopstop.net")! as URL)
        
        //Tanoi: 04/03/17 replaced above with this because the compiler said had been deprecated
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string: "http://www.hoopstop.net")! as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["address@example.com", "founder@hoopstop.net"])
        composeVC.setSubject("Check out HoopStop!")
        composeVC.setMessageBody("Hi Basketball Star!If you love to shoot hoops a lot and also travel around the US, and don't want to miss the fun when away from home, then you should check out this app for basketball aficionados from HoopStop Network. It will help you to locate basketball courts around the country. Supply information about a facility you know is good but has not yet been reviewed by HoopStop, and the name/info you supply about you will be displayed with the facility and seen by others who use the app.How cool is that ?. You might not be an NBA star like Koby Bryant but others will know that if they visit your neighborhood, they will have a good player to shoot hoops with.Launch the App Store app and download it!!", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
}

