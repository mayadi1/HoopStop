//
//  submitNewFacilityViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 2/22/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit

class submitNewFacilityViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var additionalFacilityInfo: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        additionalFacilityInfo.delegate = self
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
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        self.view.frame.origin.y == 0
            self.view.frame.origin.y -= keyboardSize.height
            additionalFacilityInfo.text = nil
            additionalFacilityInfo.textColor = UIColor.black
    }
}
