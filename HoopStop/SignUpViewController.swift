//
//  SignUpViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var additionalProfileInfo: UITextView!
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
  
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    var fileUrl: String!
    
    override func viewWillAppear(_ animated: Bool) {
        self.okButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 3
        profileImage.clipsToBounds = true
        
    }
    
    func CancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        if(self.name.text == "" || self.username.text == "" || self.email.text == "" || self.password.text == ""){
            let alert = UIAlertController(title: "Error", message: "You must fill up your information.", preferredStyle: .alert)
            let gotItButton = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
            alert.addAction(gotItButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.okButton.isEnabled = false
        FIRAuth.auth()?.createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
                self.okButton.isEnabled = true
                return
            }else{
                SVProgressHUD.show(withStatus: "Loading")
                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                }
                let rootRef = FIRDatabase.database().reference()
                rootRef.child("users").child("\(user!.uid)").child("name").setValue(self.name.text)
                rootRef.child("users").child("\(user!.uid)").child("username").setValue(self.username.text)
                rootRef.child("users").child("\(user!.uid)").child("useruid").setValue("\(user!.uid)")
                rootRef.child("users").child("\(user!.uid)").child("additionalProfileInfo").setValue(self.additionalProfileInfo.text)

                rootRef.child("users").child("\(user!.uid)").child("useremail").setValue(self.email.text)
                rootRef.child("users").child("\(user!.uid)").child("valid").setValue("yes")
                rootRef.child("users").child("\(user!.uid)").child("profileCreatedDate").setValue(FIRServerValue.timestamp())
                let changeRequest = user?.profileChangeRequest()
                changeRequest?.displayName = self.name.text
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                })
                if(self.selectedPhoto != nil){
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
                            self.dismiss(animated: true, completion: {})
                        }
                    })
                    
                })
                }else{
                    rootRef.child("users").child("\(user!.uid)").child("userProfilePic").setValue("NoPhoto")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "Great Success!")
                    self.dismiss(animated: true, completion: {})
                }
            }
    })

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        additionalProfileInfo.text = nil
        additionalProfileInfo.textColor = UIColor.black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}//End of the extension
