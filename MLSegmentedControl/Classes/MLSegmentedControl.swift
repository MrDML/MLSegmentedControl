//
//  MLSegmentedControl.swift
//  MLSegmentedControl
//
//  Created by 戴明亮 on 2018/6/15.
//

import UIKit


enum MLSegmentedControlType: Int {
    case MLSegmentedControlTypeText
    case MLSegmentedControlTypeImages
    case MLSegmentedControlTypeTextImages
}

open class MLSegmentedControl: UIControl {

    
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView.init()
        scr.scrollsToTop = false
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        return scr
    }()
    
    
    
   public var MLTitleFormatterBlock:(()-> Void)!
    
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
    
    
    
    /// 标题数组
    var sectionsTitles:Array<String>{
        didSet{
           
        }
    }
    
    /// 图片名称
    var sectionImages:Array<String>{
        didSet{
            
        }
    }
    
    /// 选中图片名称
    var sectionSelectImages:Array<String>{
        didSet{
            
        }
    }
    

    
    /// 视图背景颜色
    var backgroundColorSegment:UIColor?
    
    
    /// 展现类型
    var type:MLSegmentedControlType = .MLSegmentedControlTypeText
    

    /// 当前选中索引
    var selectedSegmentIndex = 0
    
    public convenience init(sectionsTitles sectiontitles:Array<String>){
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: nil, sectionSelectImages: sectiontitles)
        
        self.type = .MLSegmentedControlTypeText
        self.sectionsTitles = sectiontitles
        
        initialize()
    }

    
    public convenience init(sectionForImages sectionImages:Array<String>,sectionSelectImages selectImages:Array<String> ) {
         self.init(frame: CGRect.zero, sectionsTitles: nil, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        self.type = .MLSegmentedControlTypeImages
        self.sectionImages = sectionImages
        self.sectionSelectImages = selectImages
        

        initialize()
    }
    
    
    public convenience init?(sectionsTitles sectiontitles:Array<String>,sectionForImages sectionImages:Array<String>,sectionSelectImages selectImages:Array<String>) {
        if sectiontitles.count != selectImages.count {
            return nil;
        }
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        
        self.type = .MLSegmentedControlTypeTextImages
      

       
    }
    
    
    // 指定构造函数
    private init(frame: CGRect, sectionsTitles sectiontitles:Array<String>?,sectionForImages sectionImages:Array<String>?,sectionSelectImages selectImages:Array<String>?) {
     
        self.sectionsTitles = sectiontitles!
        self.sectionImages = sectionImages!
        self.sectionSelectImages = selectImages!
        super.init(frame: frame)
        defaultValue()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    
    // 设置默认值
    func defaultValue(){
        self.backgroundColorSegment = UIColor.red
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.maxX, height: self.frame.maxY)
        
    }

    func initialize(){
      self.addSubview(scrollView)

    // https://www.zybuluo.com/fiy-fish/note/589307
        /**不透明的
         使用 opaque 可以提高系统的视图绘制性能，当opaque = yes时，系统可以快速高效的绘制视图，这个时候view的alpha一定等于1
         当view.alpha小于1时，opaque一定要设置为NO,否则会发生意想不到的后果
         1.opaque默认为YES，此时view.alpha=1
         2.view,alpha小于1时，opaque一定要设置为NO
         */
     self.isOpaque = false
        
        // 当视图的size 发生变化时 会调用 drawrect 方法
     self.contentMode = .redraw
        
        
        
    }
    
    
    override open func draw(_ rect: CGRect) {
        
        // 绘制一个带有颜色的矩形
        self.backgroundColorSegment?.setFill()
        UIRectFill(self.bounds)

        switch self.type {
        case .MLSegmentedControlTypeText:
            loadSegmentedControlTypeText(rect: rect)
            break
        case .MLSegmentedControlTypeImages:
            break
        case .MLSegmentedControlTypeTextImages:
            break
        }
        
       

    }
    
    
    
    /// 加载类型一
    func loadSegmentedControlTypeText(rect:CGRect){
    
        for item in self.sectionsTitles {
            
            
        let stringWidth = 0;
        let stringHeight = 0;
            
            
            
            
        }

    }
    
    
   public func testBlock(complete:(_ a:Int, _ b:Int)-> Void){
        
    }
    
    
    
    
    /// 计算标题的size
    ///
    /// - Parameter index: 索引
    func calculateTitleSizeAtIndex(index:Int) -> CGSize{
        
        if index >= self.sectionsTitles.count {
            return  CGSize.zero
        }
        
        let title:AnyObject = self.sectionsTitles[index] as AnyObject
        
        title.isKind(of: NSAttributedString.self)
        

        MLTitleFormatterBlock = { () -> Void in
            
            
        }
        
       
        
        return CGSize.zero
    }
    
    
    
    
    
    
}
