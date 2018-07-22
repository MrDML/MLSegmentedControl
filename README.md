# MLSegmentedControl

[![CI Status](https://img.shields.io/travis/MrDML/MLSegmentedControl.svg?style=flat)](https://travis-ci.org/MrDML/MLSegmentedControl)
[![Version](https://img.shields.io/cocoapods/v/MLSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MLSegmentedControl)
[![License](https://img.shields.io/cocoapods/l/MLSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MLSegmentedControl)
[![Platform](https://img.shields.io/cocoapods/p/MLSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/MLSegmentedControl)

## Preview
![Demo](https://github.com/MrDML/MLSegmentedControl/blob/master/MLSegmentedControl.gif)
    

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MLSegmentedControl is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MLSegmentedControl'
```
```swift
//
//  DetailsViewController.swift
//  MLSegmentedControl_Example
//
//  Created by MrDML on 2018/7/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import MLSegmentedControl

enum MLSegmentedType {
case text
case image
case textImage
case none
}

class DetailsViewController: UIViewController {

var segmentedControl:MLSegmentedControl? = nil
public var type:MLSegmentedType = .none
lazy var scrollView: UIScrollView = {
let sc = UIScrollView.init()
sc.showsVerticalScrollIndicator = false
sc.isPagingEnabled = true
sc.backgroundColor = UIColor.orange
sc.delegate  = self
self.view.addSubview(sc)
return sc
}()


override func viewDidLoad() {
super.viewDidLoad()
switch type {
case .text:
exampleDemoOne()
break
case .image:
exampleDemoTwo()
break
case .textImage:
exampleDemoThree()
break
case .none:
break
}


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

let titlsArray = ["One","Two","Three","Four","Five","Six","Seven"]

let segmentedControl = MLSegmentedControl.init(sectionsTitles:titlsArray , sectionForImages: imagesArray, sectionSelectImages: seletImageArray)

let offsetTop = UIApplication.shared.statusBarFrame.height + 44

segmentedControl.frame = CGRect.init(x: 0, y: offsetTop, width: UIScreen.main.bounds.width, height: 40)
segmentedControl.borderType = .none
segmentedControl.textImageSpacing = 10
segmentedControl.imagePosition = .rightOfText
segmentedControl.segmentWidthStyle = .fixed
segmentedControl.shouldStretchSegmentsToScreenSize = true
segmentedControl.selectionIndicatorHeight = 2
segmentedControl.addTarget(self, action: #selector(changeValueToIndex(segmentcontrol:)), for: [.valueChanged])
self.view.addSubview(segmentedControl)

self.segmentedControl = segmentedControl
self.scrollView.frame = CGRect(x: 0, y:segmentedControl.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segmentedControl.frame.height - 60)

self.scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width * CGFloat(titlsArray.count), height: UIScreen.main.bounds.height)
}


func  exampleDemoTwo(){
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


let segmentedControl = MLSegmentedControl.init(sectionForImages: imagesArray, sectionSelectImages: seletImageArray)
let offsetTop = UIApplication.shared.statusBarFrame.height + 44
segmentedControl.frame = CGRect.init(x: 0, y: offsetTop, width: UIScreen.main.bounds.width, height: 40)
segmentedControl.segmentWidthStyle = .dynamic
segmentedControl.borderType = .none
segmentedControl.selectionIndicatorHeight = 2
segmentedControl.addTarget(self, action: #selector(changeValueToIndex(segmentcontrol:)), for: [.valueChanged])
segmentedControl.selectionChangeToIndexClosure = { (index:Int) -> Void in

//            print("当前索引：\(index)")
}
self.view.addSubview(segmentedControl)

self.segmentedControl = segmentedControl
self.scrollView.frame = CGRect(x: 0, y:segmentedControl.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segmentedControl.frame.height - 60)

self.scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width * CGFloat(imagesArray.count), height: UIScreen.main.bounds.height)
}


func exampleDemoOne(){
let titlsArray = ["One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten"]
let segmentedControl = MLSegmentedControl.init(sectionsTitles: titlsArray)


segmentedControl.titleFormatterClosure = { (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool) -> NSAttributedString in

if selected == true {
return NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.orange])
}
return NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.black])
}
let offsetTop = UIApplication.shared.statusBarFrame.height + 44
segmentedControl.frame = CGRect.init(x: 0, y: offsetTop, width: UIScreen.main.bounds.width, height: 40)
segmentedControl.segmentWidthStyle = .fixed

segmentedControl.imagePosition = .aboveText
segmentedControl.selectionIndicatorHeight = 2
segmentedControl.borderType = .none
segmentedControl.addTarget(self, action: #selector(changeValueToIndex(segmentcontrol:)), for: [.valueChanged])
self.view.addSubview(segmentedControl)

self.segmentedControl = segmentedControl
self.scrollView.frame = CGRect(x: 0, y:segmentedControl.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segmentedControl.frame.height - 60)

self.scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width * CGFloat(titlsArray.count), height: UIScreen.main.bounds.height)

}
@objc func changeValueToIndex(segmentcontrol:MLSegmentedControl){


let x = CGFloat(segmentcontrol.selectedSegmentIndex) * UIScreen.main.bounds.width
let rect = CGRect.init(x: x, y: self.scrollView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.scrollView.frame.height);
// contentSize width/height 不能设置为0
self.scrollView.scrollRectToVisible(rect, animated: true)
}
}




extension DetailsViewController:UIScrollViewDelegate{

func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
let index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
self.segmentedControl?.setSelectedSegmentIndex(index: index, animation: true)

scrollView.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
}

func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
scrollView.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
}


}


```


## Author

MrDML, dml1630@163.com

## License

MLSegmentedControl is available under the MIT license. See the LICENSE file for more info.
