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
import DateTimePicker

class InviteDisinviteViewController: UIViewController {
    var passedUser = [UserInfoViewController]()
    var passedImage: UIImage?
    var passedInviteType: String?
    var passedName: String?
    let userID = FIRAuth.auth()?.currentUser?.uid

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
    var found = false
    @IBAction func inviteButtonPressed(_ sender: Any) {
        if (passedInviteType == "Public"){
            for facility in self.passedUser[0].invitedAt{
                if (facility == self.passedName){
                    self.found = true
                    if (userID == nil)
                    {
                        print("Unkown user cant invite")
                        SVProgressHUD.showError(withStatus: "You need to sing up first")
                        return
                    }
                    
                    SVProgressHUD.showSuccess(withStatus: "Already invited.")
                    self.dismiss(animated: false) {
                    }
                    return
                }
            }
            if(self.found == false){
                self.pickDateTime()
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
    
    func pickDateTime()
    {
        if (userID == nil)
        {
            print("Unkown user cant invite")
            SVProgressHUD.showError(withStatus: "You need to sing up first")
            return
        }
        
        let min = Date()
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.blue
        picker.doneButtonTitle = "!! DONE DONE !!"
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isTimePickerOnly = true
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            // self.title = formatter.string(from: date)
            
            //Set date to pass
            let calendar = Calendar.current
            let hour = String(calendar.component(.hour, from: date))
            let min = String(calendar.component(.minute, from: date))
            let year = String(calendar.component(.year, from: date))
            let month = String(calendar.component(.month, from: date))
            let day = String(calendar.component(.day, from: date))
            let dateToPass = hour + ":" + min + " "
            let fullDateToPass = dateToPass + day + "/" + month + "/" + year
            

            
            self.passedUser[0].invitedAt.append(self.passedName! + " At: \(fullDateToPass)")
            self.usersFef.child(self.passedUser[0].userUid!).child("invitedAt").setValue(self.passedUser[0].invitedAt)
            SVProgressHUD.showSuccess(withStatus: "Invite sent.")
            self.dismiss(animated: false) {
            }
        }
    }

}
