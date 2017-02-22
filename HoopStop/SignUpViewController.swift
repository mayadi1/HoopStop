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

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
  
    var chechPhoto: Bool?
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    var fileUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        self.chechPhoto = false
        
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
        self.okButton.isEnabled = false
        var data = Data()
        data = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)!
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
                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                }
                let rootRef = FIRDatabase.database().reference()
                rootRef.child("users").child("\(user!.uid)").child("name").setValue(self.name.text)
                rootRef.child("users").child("\(user!.uid)").child("username").setValue(self.username.text)
                rootRef.child("users").child("\(user!.uid)").child("useruid").setValue("\(user!.uid)")
                rootRef.child("users").child("\(user!.uid)").child("useremail").setValue(self.email.text)
                rootRef.child("users").child("\(user!.uid)").child("valid").setValue("yes")
                let changeRequest = user?.profileChangeRequest()
                changeRequest?.displayName = self.name.text
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                })
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
                            print("Profile Updated")
                            self.dismiss(animated: true, completion: {})
                        }
                    })
                    
                })
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
