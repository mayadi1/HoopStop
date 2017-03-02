//
//  InviteDisinviteViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/1/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import SVProgressHUD

class InviteDisinviteViewController: UIViewController {
    var passedUser = [UserInfoViewController]()
    var passedImage: UIImage?
    @IBOutlet weak var inviteButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navItem: UINavigationItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navItem.title = passedUser[0].name
        self.imageView.image = self.passedImage
        self.textView.text = passedUser[0].additionalProfileInfo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        SVProgressHUD.showSuccess(withStatus: "Invite sent.")
        self.dismiss(animated: false) {
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) { 
        }
    }
}
