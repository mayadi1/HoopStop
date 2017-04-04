//
//  ShowPinInfoViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/28/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
protocol deleteButtonDelegate {
    func deleteButtonTap(name: String)
}

class ShowPinInfoViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var delegate: deleteButtonDelegate?
    var passedPin = [FacilityPinInfo]()
    var users = [UserInfoViewController]()
    @IBOutlet weak var inviteSwitch: UISwitch!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signInOutSwitch: UISwitch!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var navItem: UINavigationItem!
    let usersFef = FIRDatabase.database().reference().child("users")
    let userID = FIRAuth.auth()?.currentUser?.uid
    var invite = "Public"
    
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var showFacilityInfoButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.usersFef.child(userID!).child("signedInAt").observe(.value, with: { (snapshot) in
           let string = snapshot.value as! String
            if string.range(of: self.navItem.title!) != nil{
                self.signInOutSwitch.isOn = true
                self.signInLabel.text = "You are now here"
                for user in self.users{
                    if (user.userUid == self.userID){
                        let date = Date()
                        let calendar = Calendar.current
                        let hour = String(calendar.component(.hour, from: date))
                        let min = String(calendar.component(.minute, from: date))
                        let year = String(calendar.component(.year, from: date))
                        let month = String(calendar.component(.month, from: date))
                        let day = String(calendar.component(.day, from: date))
                        let dateToPass = hour + ":" + min + ". "
                        let fullDateToPass = dateToPass + day + "/" + month + "/" + year
                        let stringToPassIn = self.navItem.title! + " @" + fullDateToPass
                        user.signedInAt = stringToPassIn
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowPinInfoViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        image.addGestureRecognizer(tap)
        
        self.retriveUserInfo()
        signInOutSwitch.addTarget(self, action: #selector(self.signInOutSwitchSwitchChanged), for: .valueChanged)
        inviteSwitch.addTarget(self, action: #selector(self.inviteSwitchSwitchChanged), for: .valueChanged)
        
        self.navItem.title = passedPin[0].name
        if(passedPin[0].facilityPhoto == "NoPhoto"){
            self.image.image = UIImage(named: "facilityImage")
            self.address.text = self.passedPin[0].streetAddress! + ", " + self.passedPin[0].city! + ", " + self.passedPin[0].state! + ", " + self.passedPin[0].zip!
        }else{
            self.image.downloadedFrom(link: (self.passedPin[0].facilityPhoto)!)
            self.address.text = self.passedPin[0].streetAddress! + ", " + self.passedPin[0].city! + ", " + self.passedPin[0].state! + ", " + self.passedPin[0].zip!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if(self.okButton.title == "Delete"){
            let ref = FIRDatabase.database().reference().child("facilities").child(self.passedPin[0].zip!).child(self.passedPin[0].facilityUid!)
            ref.removeValue()
            deleteButtonTap()
            SVProgressHUD.showSuccess(withStatus: "Facility removed!")
            self.dismiss(animated: true) {
            }
        }else{
            self.dismiss(animated: true) {
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    @IBAction func showFacilityInfoButtonPressed(_ sender: Any) {
        if(self.showFacilityInfoButton.titleLabel?.text == "Show Members"){
            self.showFacilityInfoButton.setTitle("Show Facility info", for: .normal)
            self.tableView.isUserInteractionEnabled = true
            self.view.addSubview(self.tableView)
        }
        if(self.showFacilityInfoButton.titleLabel?.text == "Show Facility info"){
            self.showFacilityInfoButton.setTitle("Show Members", for: .normal)
            let textView = UITextView(frame: tableView.frame)
            textView.text = self.passedPin[0].additionalFacilityInfo
            textView.isUserInteractionEnabled = false
            textView.backgroundColor = UIColor.yellow
            textView.font = UIFont.boldSystemFont(ofSize: 22)
            self.tableView.isUserInteractionEnabled = false
            self.view.addSubview(textView)
            return
        }
    }
    func deleteButtonTap(){
        delegate?.deleteButtonTap(name: self.passedPin[0].facilityUid!)
    }
    func signInOutSwitchSwitchChanged(){
        if(self.signInOutSwitch.isOn == true){
            self.signInLabel.text = "You are now here"
            let date = Date()
            let calendar = Calendar.current
            let hour = String(calendar.component(.hour, from: date))
            let min = String(calendar.component(.minute, from: date))
            let year = String(calendar.component(.year, from: date))
            let month = String(calendar.component(.month, from: date))
            let day = String(calendar.component(.day, from: date))
            
            let dateToPass = hour + ":" + min + ". "
            let fullDateToPass = dateToPass + day + "/" + month + "/" + year
            let stringToPassIn = self.passedPin[0].name! + " @" + fullDateToPass
            usersFef.child((FIRAuth.auth()?.currentUser?.uid)!).child("signedInAt").setValue(stringToPassIn)
        }else{
            usersFef.child((FIRAuth.auth()?.currentUser?.uid)!).child("signedInAt").setValue("Not signed in at any facility")
            for user in self.users{
                if (user.userUid == self.userID){
                    user.signedInAt = "Not signed in at any facility"
                    self.tableView.reloadData()
                }
            }
            self.signInLabel.text = "You can sign in here"
        }
    }
    
    func inviteSwitchSwitchChanged(){
        if(self.inviteSwitch.isOn == true){
            let alert = UIAlertController(title: "Invite Friends", message: "Will this be a PRIVATE or PUBLIC invitation?. Select a member from the table to invite.", preferredStyle: .alert)
            let publicInvite = UIAlertAction(title: "Public", style: .default) { (UIAlertAction) in
                self.invite = "Public"
            }
            let privateInvite = UIAlertAction(title: "Private", style: .default) { (UIAlertAction) in
                self.invite = "Private"
            }
            alert.addAction(publicInvite)
            alert.addAction(privateInvite)
            self.show(alert, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "profile-1")
        var found = false
        for facility in self.users[indexPath.row].invitedAt{
            if (facility == self.navItem.title){
                found = true
            }
        }
        if (found == true){
            cell.textLabel?.text = users[indexPath.row].name! + "*Invited"
            cell.textLabel?.backgroundColor = UIColor.yellow
        }
        if ( found == false){
            cell.textLabel?.text = users[indexPath.row].name
        }
        
        DispatchQueue.main.async {
            cell.imageView?.downloadedFrom(link: self.users[indexPath.row].userProfilePic!)
            //cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2.0
        }
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        if (self.users[indexPath.row].signedInAt == "Not signed in at any facility"){
            cell.detailTextLabel?.text = self.users[indexPath.row].signedInAt
            cell.detailTextLabel?.backgroundColor = UIColor.white
        }else{
            cell.detailTextLabel?.text = "Signed in At: " + self.users[indexPath.row].signedInAt!
            cell.detailTextLabel?.backgroundColor = UIColor.green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func retriveUserInfo(){
        usersFef.observe(.childAdded, with: { (snapshot) in
            let user = snapshot.value as? [String: Any]
            let tempUser = UserInfoViewController(passedName: (user!["name"])! as! String, passedUserProfilePic: (user!["userProfilePic"])! as! String, passedEmail: (user!["useremail"])! as! String, passedUserName: (user!["username"]! as! String), passedUid: (user!["useruid"]! as! String),passedAdditionalProfileInfo: (user!["additionalProfileInfo"])! as! String, passedSignedInAt: (user!["signedInAt"])! as! String, passedInvitedAt: (user!["invitedAt"])! as! [String], passedRole: (user!["role"]! as! String))
            if(tempUser.userUid == self.userID){
                if(tempUser.role == "admin" || self.passedPin[0].userIDPostingThis == self.userID){
                    self.okButton.title = "Delete"
                    self.okButton.tintColor = UIColor.red
                }
            }
            self.users.append(tempUser)
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUsersFef = FIRDatabase.database().reference().child("users").child(users[indexPath.row].userUid!).child("invitedAt")
        selectedUsersFef.observe(.value, with: { (snapshot) in
            self.users[indexPath.row].invitedAt = snapshot.value as! [String]
            self.tableView.reloadData()
        })
        let cell = tableView.cellForRow(at: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteDisinvite") as! InviteDisinviteViewController
        vc.passedUser = [users[indexPath.row]]
        vc.passedImage = cell?.imageView?.image
        vc.passedInviteType = self.invite
        vc.passedName = self.navItem.title
        tableView.deselectRow(at: indexPath, animated: false)
        self.present(vc, animated: true) {}
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func selectPhoto(_ tap: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "fullImageView") as! FullScreenImageViewController
        vc.passedImage = self.image.image!
        self.present(vc, animated: true) {
        }
    }
    
}
