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
        
//       exampleDemo()
        
        
       exampleDemo2()
      
    }

    
    
    func  exampleDemo2(){
        let image =  (UIImage.init(named: "1-selected"))!
       
        let images:Array<UIImage> = [image,image,image,image,image]
       let segmentedControl = MLSegmentedControl.init(sectionForImages: images, sectionSelectImages: images)
       segmentedControl.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
//                segmentedControl.segmentWidthStyle = .MLSegmentedControlSegmentWidthStyleFixed
//        segmentedControl.selectionStyle = .MLHMSegmentedControlSelectionStyleBox
//        segmentedControl.selectionIndicatorLocation = .MLSegmentedControlSelectionIndicatorLocationUp
//
//        segmentedControl.shouldStretchSegmentsToScreenSize = true
//        segmentedControl.borderType = .None
//        segmentedControl.selectedSegmentIndex = MLSegmentedControlNoSegment.NoSelectSegment.rawValue
        
        self.view.addSubview(segmentedControl)
    }
    
    
    func exampleDemo(){
        let titles = ["One","Two","Three","1","2","3","4","5","6","7"]
//        let images = ["imageName","imageName","imageName","1","2","3","4","5","6","7"]
//        let selectImages = ["imageName","imageName","imageName","1","2","3","4","5","6","7"]
       
        let segmentedControl = MLSegmentedControl.init(sectionsTitles: titles)
        
//        segmentedControl?.titleFormatterBlock = { (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool) -> NSAttributedString in
        
//            return NSAttributedString.init()
//        }
        segmentedControl.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.segmentWidthStyle = .MLSegmentedControlSegmentWidthStyleFixed
        segmentedControl.selectionStyle = .MLHMSegmentedControlSelectionStyleBox
        segmentedControl.selectionIndicatorLocation = .MLSegmentedControlSelectionIndicatorLocationUp

        segmentedControl.shouldStretchSegmentsToScreenSize = true
        segmentedControl.borderType = .None
        segmentedControl.selectedSegmentIndex = MLSegmentedControlNoSegment.NoSelectSegment.rawValue
        self.view.addSubview(segmentedControl)
    }
    
    
}

