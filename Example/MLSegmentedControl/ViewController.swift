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
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setTableView()
    }
    
    
    
    func setTableView(){
        
        
        
    }
    
    
    
    func  exampleDemoThree(){

        var imagesArray:Array<UIImage> = []
        for index in 0...6 {
            let str =  String.init(format: "%02d", index + 1)
            let image = (UIImage.init(named: str))!
            imagesArray.append(image)
            
        }
        
        var seletImageArray:Array<UIImage> = []
        for index in 0...6 {
            let str =  String.init(format: "%02dselected", index + 1)
            let image = (UIImage.init(named: str))!
            seletImageArray.append(image)
            
        }

         let segmentedControl = MLSegmentedControl.init(sectionsTitles: ["One","Two","Three","Four","Five","Six","Seven"], sectionForImages: imagesArray, sectionSelectImages: seletImageArray)
         segmentedControl.frame = CGRect.init(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 40)
        segmentedControl.borderType = .none
        segmentedControl.textImageSpacing = 10
        segmentedControl.imagePosition = .rightOfText
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.shouldStretchSegmentsToScreenSize = true
         self.view.addSubview(segmentedControl)
    }
    
    
    func  exampleDemoTwo(){
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
    
    
    func exampleDemoOne(){
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

//
//extension ViewController:UITabBarDelegate,UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    
//    
//    
//}









