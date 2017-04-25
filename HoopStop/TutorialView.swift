//
//  TutorialView.swift
//  HoopStop
//
//  Created by Mohamed Ayadi on 4/24/17.
//  Copyright © 2017 Mohamed Ayadi. All rights reserved.
//


import UIKit

class TutorialView: UIViewController {
    
    let window = windowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["Tap on facility to see information","Find specific location to submit new facility","Sign in/out from facility using switcher","Use the invite button to invite friends to facility"]
        let images = ["img1","img2","img3","img4"]
        window.basicView(ViewController: self, arrayImages: images, arrayTitles: titles)
    }
}

