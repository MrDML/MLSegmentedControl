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
//       exampleDemo2()
//      exampleDemo3()
    }
    func  exampleDemo3(){
         let image =  (UIImage.init(named: "01"))!
        let images:Array<UIImage> = [image,image,image,image,image,image,image]
         let segmentedControl = MLSegmentedControl.init(sectionsTitles: ["One","Two","three","four","five","six","seven"], sectionForImages: images, sectionSelectImages: images)
         segmentedControl.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.borderType = .None
//        segmentedControl.textImageSpacing = 10
        segmentedControl.imagePosition = .BehindText
        segmentedControl.segmentWidthStyle = .Fixed
//        segmentedControl.shouldStretchSegmentsToScreenSize = true
         self.view.addSubview(segmentedControl)
    }
    
    
    func  exampleDemo2(){
        let image =  (UIImage.init(named: "01"))!
       
        let images:Array<UIImage> = [image,image,image]
       let segmentedControl = MLSegmentedControl.init(sectionForImages: images, sectionSelectImages: images)
       segmentedControl.frame = CGRect.init(x: 0, y: 150, width: UIScreen.main.bounds.width, height: 40)
                segmentedControl.segmentWidthStyle = .Dynamic
        segmentedControl.borderType = .None
        self.view.addSubview(segmentedControl)
    }
    
    
    func exampleDemo(){
        let titles = ["One","Two","Three","1","2","3","4","5","6","7"]
//        let images = ["imageName","imageName","imageName","1","2","3","4","5","6","7"]
//        let selectImages = ["imageName","imageName","imageName","1","2","3","4","5","6","7"]
       
        let segmentedControl = MLSegmentedControl.init(sectionsTitles: titles)
        

        segmentedControl.titleFormatterBlock = { (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool) -> NSAttributedString in
//            NSAttributedString.init(string: <#T##String#>, attributes: <#T##[NSAttributedStringKey : Any]?#>)
            return NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.yellow])
        }
        segmentedControl.frame = CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.segmentWidthStyle = .Fixed

        segmentedControl.imagePosition = .AboveText

        segmentedControl.borderType = .None
        self.view.addSubview(segmentedControl)
    }
    
    
}

