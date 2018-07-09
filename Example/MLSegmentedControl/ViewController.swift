//
//  ViewController.swift
//  MLSegmentedControl
//
//  Created by MrDML on 06/15/2018.
//  Copyright (c) 2018 MrDML. All rights reserved.
//

import UIKit
import MLSegmentedControl
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       exampleDemo()
      
    }

    
    func exampleDemo(){
        let titles = ["One","Two","Three"]
        let images = ["imageName","imageName","imageName"]
        let selectImages = ["imageName","imageName","imageName"]
        let segmentedControl = MLSegmentedControl.init(sectionsTitles: titles, sectionForImages: images, sectionSelectImages: selectImages)
        
        segmentedControl?.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
        self.view.addSubview(segmentedControl!)
    }
    
    
}

