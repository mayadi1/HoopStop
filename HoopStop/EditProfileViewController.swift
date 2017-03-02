//
//  EditProfileViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/23/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import SVProgressHUD

class EditProfileViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    let ref = FIRDatabase.database().reference()
    let userID = FIRAuth.auth()?.currentUser?.uid
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    var fileUrl: String!
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateButton.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.email.isEnabled = false
        self.password.isEnabled = false
        let ref = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value
            let tempProfileInfoArray = value as! NSDictionary
            self.name.text = tempProfileInfoArray["name"] as? String
            self.username.text = tempProfileInfoArray["username"] as? String
            self.email.text = tempProfileInfoArray["useremail"] as? String
            self.password.text = "******"
            if((tempProfileInfoArray["userProfilePic"] as? String)! == "NoPhoto"){
                self.profileImage.image = UIImage(named: "profile-1")
            }else{
            self.profileImage.downloadedFrom(link: (tempProfileInfoArray["userProfilePic"] as? String)!)
            }
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 3
        profileImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) { 
        }
    }
    @IBAction func updateButtonPressed(_ sender: Any) {
        self.updateButton.isEnabled = false
        SVProgressHUD.show(withStatus: "Loading")
        let rootRef = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        rootRef.child("users").child("\(user!.uid)").child("name").setValue(self.name.text)
        rootRef.child("users").child("\(user!.uid)").child("username").setValue(self.username.text)
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = self.name.text
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        })
        if(selectedPhoto != nil){
        var data = Data()
        let newImage = self.ResizeImage(image: self.profileImage.image!,targetSize: CGSize(width: 390, height: 390.0))
        data = UIImageJPEGRepresentation(newImage, 0.1)!
        let filePath = "profileImage/\(user!.uid)"
        let metadata =  FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(filePath).put(data, metadata: metadata, completion: { (metadata, error) in
            if let error = error{
                print("\(error)")
                return
            }
            self.fileUrl = metadata?.downloadURLs![0].absoluteString
            rootRef.child("users").child("\(user!.uid)").child("userProfilePic").setValue(self.fileUrl)
            let changeREquestPhoto = user!.profileChangeRequest()
            changeREquestPhoto.photoURL = URL(string: self.fileUrl)
            changeREquestPhoto.commitChanges(completion: { (error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }else{
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "Great Success!")
                    self.isEditing = false
                    self.dismiss(animated: true, completion: {})
                }
            })
            
        })
        }else{
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "Great Success!")
            self.isEditing = false
            self.dismiss(animated: true, completion: {})
        }
    }
    
    func selectPhoto(_ tap: UITapGestureRecognizer) {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        let photoOptionAlertController = UIAlertController(title: "SourceType?", message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Take a Camera Shot", style: .default, handler: { (UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let photoLibraryAction = UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
        }
        
        photoOptionAlertController.addAction(cameraAction)
        photoOptionAlertController.addAction(photoLibraryAction)
        photoOptionAlertController.addAction(cancelAction)
        self.present(photoOptionAlertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
