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
        let titles = ["Touch and turn the hexagon","Select the same color as the ball","If the color is different the ball fall","Plays with both hands to spin faster"]
        let images = ["img1","img2","img3","img4"]
        window.basicView(ViewController: self, arrayImages: images, arrayTitles: titles)
    }
}

