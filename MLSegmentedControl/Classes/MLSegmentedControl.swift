//
//  MLSegmentedControl.swift
//  MLSegmentedControl
//
//  Created by 戴明亮 on 2018/6/15.
//

import UIKit

open class MLSegmentedControl: UIControl {

    
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView.init()
        scr.scrollsToTop = false
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        return scr
    }()
    
    
    // 条状指示器
    lazy var selectionIndicatorStripLayer: CALayer = {
        let stripLayer = CALayer()
        return stripLayer
    }()
    
    // 箭头指示器
    lazy var selectionIndicatorArrowLayer: CALayer = {
        let arrowLayer  = CALayer()
        return arrowLayer
    }()
    
    // 矩形盒指示器
    lazy var selectionIndicatorBoxLayer: CALayer = {
        let  boxLayer  = CALayer()
        return boxLayer
    }()
    
    
    
    
    
    // default = 0
    var selectedSegmentIndex = 0
    
    

    public init(titles:Array<String>,images:Array<String>) {
        self.init()
        initialize()
    }
    
    
    public init(titles:Array<String>) {
        self.init()
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    

    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override open func draw(_ rect: CGRect) {
        
    }
    
    
    func initialize(){
      self.addSubview(scrollView)
      self.backgroundColor = UIColor.white
        
        
        
        // 当视图的size 发生变化时 会调用 drawrect 方法
        self.contentMode = .redraw
        
        
        
    }
    
    
    
    
    
    
    
    
    
}
