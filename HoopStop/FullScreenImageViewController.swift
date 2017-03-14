//
//  FullScreenImageViewController.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 3/14/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var passedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.passedImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
}
