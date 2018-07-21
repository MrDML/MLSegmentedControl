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
       exampleDemo2()
       exampleDemo3()
    }
    func  exampleDemo3(){
        
        let image01 = (UIImage.init(named: "01"))!
        let image02 = (UIImage.init(named: "02"))!
        let image03 = (UIImage.init(named: "03"))!
        let image04 = (UIImage.init(named: "04"))!
        let image05 = (UIImage.init(named: "05"))!
        let image06 = (UIImage.init(named: "06"))!
        let image07 = (UIImage.init(named: "07"))!
        
        let slectedImage01 = (UIImage.init(named: "01selected"))!
        let slectedImage02 = (UIImage.init(named: "02selected"))!
        let slectedImage03 = (UIImage.init(named: "03selected"))!
        let slectedImage04 = (UIImage.init(named: "04selected"))!
        let slectedImage05 = (UIImage.init(named: "05selected"))!
        let slectedImage06 = (UIImage.init(named: "06selected"))!
        let slectedImage07 = (UIImage.init(named: "07selected"))!
        
     
        
        let images:Array<UIImage> = [image01,image02,image03,image04,image05,image06,image07]
        
        let selectedimags:Array<UIImage> = [slectedImage01,slectedImage02,slectedImage03,slectedImage04,slectedImage05,slectedImage06,slectedImage07]
        
         let segmentedControl = MLSegmentedControl.init(sectionsTitles: ["One","Two","three","four","five","six","seven"], sectionForImages: images, sectionSelectImages: selectedimags)
         segmentedControl.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.borderType = .none
        segmentedControl.textImageSpacing = 10
        segmentedControl.imagePosition = .rightOfText
        segmentedControl.segmentWidthStyle = .fixed
//        segmentedControl.shouldStretchSegmentsToScreenSize = true
         self.view.addSubview(segmentedControl)
    }
    
    
    func  exampleDemo2(){
        let image =  (UIImage.init(named: "01"))!
       
        let images:Array<UIImage> = [image,image,image]
       let segmentedControl = MLSegmentedControl.init(sectionForImages: images, sectionSelectImages: images)
       segmentedControl.frame = CGRect.init(x: 0, y: 150, width: UIScreen.main.bounds.width, height: 40)
                segmentedControl.segmentWidthStyle = .dynamic
        segmentedControl.borderType = .none

        segmentedControl.selectionChangeToIndexClosure = { (index:Int) -> Void in
            
            print("当前索引：\(index)")
        }
        self.view.addSubview(segmentedControl)
    }
    
    
    func exampleDemo(){
        let titles = ["One","Two","Three","1","2","3","4","5","6","7"]
        let segmentedControl = MLSegmentedControl.init(sectionsTitles: titles)
        

        segmentedControl.titleFormatterClosure = { (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool) -> NSAttributedString in

            if selected == true {
                return NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.orange])
            }
            return NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.black])
        }
        segmentedControl.frame = CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.segmentWidthStyle = .fixed

        segmentedControl.imagePosition = .aboveText

        segmentedControl.borderType = .none
        segmentedControl.addTarget(self, action: #selector(changeValueToIndex(segmentcontrol:)), for: [.valueChanged])
        self.view.addSubview(segmentedControl)
    }
    @objc func changeValueToIndex(segmentcontrol:MLSegmentedControl){
        
        print("当前索引：\(segmentcontrol.selectedSegmentIndex)")
    }
    
    
}

