//
//  InviteDisinviteViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/1/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class InviteDisinviteViewController: UIViewController {
    var passedUser = [UserInfoViewController]()
    var passedImage: UIImage?
    var passedInviteType: String?
    var passedName: String?
    @IBOutlet weak var inviteButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navItem: UINavigationItem!
    let usersFef = FIRDatabase.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navItem.title = passedUser[0].name
        self.imageView.image = self.passedImage
        if (passedUser[0].additionalProfileInfo == "Additional Profile Info" ){
            self.textView.text = "No info"
        }else{
            self.textView.text = passedUser[0].additionalProfileInfo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        if (passedInviteType == "Public"){
            var found = false
            for facility in self.passedUser[0].invitedAt{
                if (facility == self.passedName){
                    found = true
                    SVProgressHUD.showSuccess(withStatus: "Already invited.")
                    self.dismiss(animated: false) {
                    }
                    return
                }
            }
            if(found == false){
                self.passedUser[0].invitedAt.append(self.passedName!)
                usersFef.child(self.passedUser[0].userUid!).child("invitedAt").setValue(self.passedUser[0].invitedAt)
                SVProgressHUD.showSuccess(withStatus: "Invite sent.")
                self.dismiss(animated: false) {
                }
            }

        }else{
            SVProgressHUD.showSuccess(withStatus: "Invite sent.")
            self.dismiss(animated: false) {
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) { 
        }
    }
}
