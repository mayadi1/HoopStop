//
//  submitNewFacilityViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import Firebase
import SVProgressHUD

class submitNewFacilityViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, ButtonDelegate {
    @IBOutlet weak var facilityName: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addPhotoImage: UIImageView!
    @IBOutlet weak var additionalFacilityInfo: UITextView!
    var locationManager = CLLocationManager()
    let userID = FIRAuth.auth()?.currentUser?.uid
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    var fileUrl: String!
    var lat = 0.0
    var long = 0.0
    var autoChilSigned = "text"
    override func viewWillAppear(_ animated: Bool) {
        self.okButton.isEnabled = true
    }
    
    internal func onButtonTap(_ placemark: MKPlacemark) {
        let address =  placemark.title?.components(separatedBy: ", ")
        let statezipString = address?[2].components(separatedBy: " ")
        self.streetAddress.text = address?[0]
        self.city.text = address?[1]
        self.state.text = statezipString?[0]
        self.zip.text = statezipString?[2]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        additionalFacilityInfo.delegate = self
        if (CLLocationManager.locationServicesEnabled()){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setAddress()
        }else{
            #if debug
                print("Location services are not enabled");
            #endif
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        addPhotoImage.addGestureRecognizer(tap)
        addPhotoImage.layer.cornerRadius = addPhotoImage.frame.size.height / 3
        addPhotoImage.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if(self.facilityName.text == "" || self.streetAddress.text == "" || self.city.text == "" || self.state.text == "" || self.zip.text == ""){
            let alert = UIAlertController(title: "Error", message: "You must fill up the missing information.", preferredStyle: .alert)
            let gotItButton = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
            alert.addAction(gotItButton)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.okButton.isEnabled = false
        getLatLong()
        SVProgressHUD.show(withStatus: "Loading")
        let rootRef = FIRDatabase.database().reference()
        let autoChild = rootRef.childByAutoId().key
        self.autoChilSigned = autoChild
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("name").setValue(self.facilityName.text)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("streetAddress").setValue(self.streetAddress.text)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("facilityUid").setValue(autoChild)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("city").setValue(self.city.text)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("state").setValue(self.state.text)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("zip").setValue(self.zip.text)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("forum").setValue(["first"])

        if(additionalFacilityInfo.text == "Additional Facility Info"){
            rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("additionalFacilityInfo").setValue("No Info")

        }else{
            rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("additionalFacilityInfo").setValue(self.additionalFacilityInfo.text)
        }
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("userIDPostingThis").setValue(self.userID)
        rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("addedDate").setValue(FIRServerValue.timestamp())
        if(selectedPhoto != nil){
        var data = Data()
        let newImage = self.ResizeImage(image: self.addPhotoImage.image!,targetSize: CGSize(width: 390, height: 390.0))
        data = UIImageJPEGRepresentation(newImage, 0.1)!
        let path = "\(userID)++\(autoChild)"
        let filePath = "facilitiesImage/\(path)"
        let metadata =  FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(filePath).put(data, metadata: metadata, completion: { (metadata, error) in
            if let error = error{
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }
            self.fileUrl = metadata?.downloadURLs![0].absoluteString
            rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("facilityPhoto").setValue(self.fileUrl)
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "Great Success!")
            self.isEditing = false
            self.dismiss(animated: true, completion: {})
        })
        }else{
            rootRef.child("facilities").child(self.zip.text!).child("\(autoChild)").child("facilityPhoto").setValue("NoPhoto")
            SVProgressHUD.dismiss()
            SVProgressHUD.showSuccess(withStatus: "Great Success!")
            self.isEditing = false
            self.dismiss(animated: true, completion: {})
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        additionalFacilityInfo.text = nil
        additionalFacilityInfo.textColor = UIColor.black
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
    
    func setAddress(){
        locationManager.startUpdatingLocation()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Address dictionary
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.streetAddress.text = locationName as String
            }
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.city.text = city as String
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                self.zip.text = zip as String
            }
            // state
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                self.state.text = state as String
            }
            // Country
            //if let country = placeMark.addressDictionary!["Country"] as? NSString {
            //}
        })
        self.locationManager.stopUpdatingLocation()
    }
    @IBAction func clearButtonPressed(_ sender: Any) {
            self.facilityName.text = nil
            self.streetAddress.text = nil
            self.city.text = nil
            self.zip.text = nil
            self.state.text = nil
            additionalFacilityInfo.text = nil
    }
    @IBAction func thisLocationButtonPressed(_ sender: Any) {
        setAddress()
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
        self.addPhotoImage.image = selectedPhoto
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
    
    func getLatLong(){
        let rootRef = FIRDatabase.database().reference()
        let address: String = "\(self.streetAddress.text!), \(self.city.text!), \(self.state.text!), USA"
        let geocoder = CLGeocoder()
        DispatchQueue.global(qos: .userInitiated).async {
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks {
                    if placemarks.count != 0 {
                        let coordinates = placemarks.first!.location?.coordinate
                        self.lat = (coordinates?.latitude)!
                        self.long = (coordinates?.longitude)!
                        rootRef.child("facilities").child(self.zip.text!).child("\(self.autoChilSigned)").child("lat").setValue(self.lat)
                        rootRef.child("facilities").child(self.zip.text!).child("\(self.autoChilSigned)").child("long").setValue(self.long)
                    }
                }
            }
        }

    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "searchLocation")
      let newVc = vc.childViewControllers[0] as! ViewController
        newVc.delegate = self
        self.present(vc, animated: true) {}
    }
}
