//
//  AddCommentViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 4/24/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit
import Firebase

class AddCommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
    var passedPin = [FacilityPinInfo]()
    var comments: [String]?
    
    override func viewWillAppear(_ animated: Bool) {
        comments?.removeAll()
         let ref = FIRDatabase.database().reference().child("facilities").child(self.passedPin[0].zip!).child(self.passedPin[0].facilityUid!).child("forum")

        ref.observe(.value, with: { (snapshot) in
            self.comments = snapshot.value as? [String]
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

      @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: false) {
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        self.comments?.append(self.commentTextField.text!)
        _ = FIRDatabase.database().reference().child("facilities").child(self.passedPin[0].zip!).child(self.passedPin[0].facilityUid!).child("forum").setValue(self.comments)
        self.dismiss(animated: false) {
        }
    }
}
