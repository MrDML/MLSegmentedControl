//
//  MLSegmentedControl.swift
//  MLSegmentedControl
//
//  Created by 戴明亮 on 2018/6/15.
//

import UIKit



/// 设置类型
///
/// - MLSegmentedControlTypeText: <#MLSegmentedControlTypeText description#>
/// - MLSegmentedControlTypeImages: <#MLSegmentedControlTypeImages description#>
/// - MLSegmentedControlTypeTextImages: <#MLSegmentedControlTypeTextImages description#>
enum MLSegmentedControlType: Int {
    case MLSegmentedControlTypeText
    case MLSegmentedControlTypeImages
    case MLSegmentedControlTypeTextImages
}


///  SegmentWidth 标题是固定/动态
///
/// - MLSegmentedControlSegmentWidthStyleFixed: <#MLSegmentedControlSegmentWidthStyleFixed description#>
/// - MLSegmentedControlSegmentWidthStyleDynamic: <#MLSegmentedControlSegmentWidthStyleDynamic description#>
enum MLSegmentedControlSegmentWidthStyle: Int {
    case MLSegmentedControlSegmentWidthStyleFixed
    case MLSegmentedControlSegmentWidthStyleDynamic
}



/// 选中样式
///
/// - MLSegmentedControlSelectionStyleTextWidthStripe: <#MLSegmentedControlSelectionStyleTextWidthStripe description#>
/// - MLSegmentedControlSelectionStyleFullWidthStripe: <#MLSegmentedControlSelectionStyleFullWidthStripe description#>
/// - MLHMSegmentedControlSelectionStyleBox: <#MLHMSegmentedControlSelectionStyleBox description#>
/// - MLSegmentedControlSelectionStyleArrow: <#MLSegmentedControlSelectionStyleArrow description#>
enum MLSegmentedControlSelectionStyle:Int {
    // 线条的宽度和文本size相等
    case MLSegmentedControlSelectionStyleTextWidthStripe
    // 线条和item相等
    case MLSegmentedControlSelectionStyleFullWidthStripe
    // 填充整个item
    case MLHMSegmentedControlSelectionStyleBox
    // 选中箭头样式
    case MLSegmentedControlSelectionStyleArrow
}



/// 线条位置
///
/// - MLSegmentedControlSelectionIndicatorLocationUp: <#MLSegmentedControlSelectionIndicatorLocationUp description#>
/// - MLSegmentedControlSelectionIndicatorLocationDown: <#MLSegmentedControlSelectionIndicatorLocationDown description#>
/// - MLSegmentedControlSelectionIndicatorLocationNone: <#MLSegmentedControlSelectionIndicatorLocationNone description#>
enum MLSegmentedControlSelectionIndicatorLocation:Int {
    case MLSegmentedControlSelectionIndicatorLocationUp
    case MLSegmentedControlSelectionIndicatorLocationDown
    case MLSegmentedControlSelectionIndicatorLocationNone
}



struct MLSegmentedControlBorderType:OptionSet {
    let rawValue: UInt
    static let None = MLSegmentedControlBorderType(rawValue: 0) // 000000

    static let Top = MLSegmentedControlBorderType(rawValue: 1 << 0) // 000001

    static let Bottom = MLSegmentedControlBorderType(rawValue: 1 << 1) // 000010

    static let Left = MLSegmentedControlBorderType(rawValue: 1 << 2)// 000100

    static let Right = MLSegmentedControlBorderType(rawValue: 1 << 3)// 001000

    
}



/// 图片位置
///
/// - MLSegmentedControlImagePositionBehindText: <#MLSegmentedControlImagePositionBehindText description#>
/// - MLSegmentedControlImagePositionLeftOfText: <#MLSegmentedControlImagePositionLeftOfText description#>
/// - MLSegmentedControlImagePositionRightOfText: <#MLSegmentedControlImagePositionRightOfText description#>
/// - MLSegmentedControlImagePositionAboveText: <#MLSegmentedControlImagePositionAboveText description#>
/// - MLSegmentedControlImagePositionBelowText: <#MLSegmentedControlImagePositionBelowText description#>
enum MLSegmentedControlImagePosition {
    case MLSegmentedControlImagePositionBehindText
    case MLSegmentedControlImagePositionLeftOfText
    case MLSegmentedControlImagePositionRightOfText
    case MLSegmentedControlImagePositionAboveText
    case MLSegmentedControlImagePositionBelowText
    
}






open class MLSegmentedControl: UIControl {

    
    lazy var scrollView: UIScrollView = {
        let scr = UIScrollView.init()
        scr.scrollsToTop = false
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        return scr
    }()
    
    typealias MLTitleFormatterBlock = (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool)-> NSAttributedString
    
    
     var titleFormatterBlock:MLTitleFormatterBlock?
    
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
    
    /// 标题的宽度是固定还是动态
    var segmentWidthStyle:MLSegmentedControlSegmentWidthStyle = .MLSegmentedControlSegmentWidthStyleDynamic
    
    /// 选中样式
    var selectionStyle:MLSegmentedControlSelectionStyle = MLSegmentedControlSelectionStyle.MLSegmentedControlSelectionStyleTextWidthStripe
    
    /// <#Description#>
    var borderType:MLSegmentedControlBorderType = MLSegmentedControlBorderType.Top
    
    
    /// 线条位置
    var selectionIndicatorLocation:MLSegmentedControlSelectionIndicatorLocation = MLSegmentedControlSelectionIndicatorLocation.MLSegmentedControlSelectionIndicatorLocationUp
    
    /// 图片位置
    var imagePosition:MLSegmentedControlImagePosition = MLSegmentedControlImagePosition.MLSegmentedControlImagePositionAboveText

    /// 当前选中索引
    var selectedSegmentIndex = 0
    
    // segment 宽度
    var segmentWidth:CGFloat = 0
    
    /// 指示线条的高度
    var selectionIndicatorHeight:CGFloat = 0
    
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
        
        self.updateSegmentsRects()
        
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
    
    /// 更新视图位置
    func updateSegmentsRects(){
        
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        if self.sectionsTitles.count > 0 {
            self.segmentWidth = self.frame.size.width  / CGFloat(self.sectionsTitles.count)
        }
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize.init(width: totalSegmentedControlWidth(), height: self.frame.size.height)
        
    }
    
 
    func totalSegmentedControlWidth() -> CGFloat {
        return CGFloat(self.sectionsTitles.count) * self.segmentWidth;
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
            loadSegmentedControlTypeText(rect: rect)
            break
        }
        
       

    }
    
    
    
    /// 加载类型一
    func loadSegmentedControlTypeText(rect:CGRect){
    
        

        
        var i:Int = 0
        for item in self.sectionsTitles {
   
            var stringWidth:CGFloat = 0;
            var stringHeight:CGFloat = 0;
            let size = self .calculateTitleSizeAtIndex(index: i)
            stringWidth = size.width
            stringHeight = size.height
            
            var rectDiv:CGRect = CGRect.zero
            var fullRect:CGRect = CGRect.zero
            
      
            let locationUp:Bool = self.selectionIndicatorLocation == MLSegmentedControlSelectionIndicatorLocation.MLSegmentedControlSelectionIndicatorLocationUp ? true : false
            
            // 非选中Box样式
            let selectionStyleNotBox = self.selectionStyle != MLSegmentedControlSelectionStyle.MLHMSegmentedControlSelectionStyleBox ? true : false
            
            
            let notBoxvalue = CGFloat(selectionStyleNotBox.hashValue)
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.size.height - notBoxvalue * self.selectionIndicatorHeight) * 0.5 - stringHeight * 0.5 + locationUpValue * self.selectionIndicatorHeight
            
          
            var rect:CGRect = CGRect.zero
            if segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleFixed {
                let x = self.segmentWidth * CGFloat(i) + (self.segmentWidth - segmentWidth) * 0.5
                rect = CGRect.init(x: CGFloat(roundf(Float(x))), y: CGFloat(roundf(Float(y))), width: CGFloat(roundf(Float(stringWidth))), height: CGFloat(roundf(Float(stringHeight))))
            }else{
                let x = self.segmentWidth * CGFloat(i) + (self.segmentWidth - segmentWidth) * 0.5
                rect = CGRect.init(x: CGFloat(roundf(Float(x))), y: CGFloat(roundf(Float(y))), width: CGFloat(roundf(Float(stringWidth))), height: CGFloat(roundf(Float(stringHeight))))
            }
            
        
            let titleLayer = CATextLayer.init()
            titleLayer.frame = rect
            titleLayer.contentsScale = UIScreen.main.scale
            let str = NSAttributedString.init(string: "hellow", attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)])
            titleLayer.string = str;
            titleLayer.alignmentMode = kCAAlignmentCenter
            
            self.scrollView.layer.addSublayer(titleLayer)
            
            
            i += 1;

        }

    }
    
 
    
    
    
    
    /// 计算标题的size
    ///
    /// - Parameter index: 索引
    func calculateTitleSizeAtIndex(index:Int) -> CGSize{
        
        if index >= self.sectionsTitles.count {
            return  CGSize.zero
        }
        
        var size = CGSize.zero
        let title = self.sectionsTitles[index]
        let selected:Bool = (index == self.selectedSegmentIndex) ? true:false
//        let a = self.titleFormatterBlock
        if (!title.isEmpty && self.titleFormatterBlock == nil) {
            
            let title:NSString = title as NSString
            size =  title.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont .systemFont(ofSize: 19)], context: nil).size
 
        }else if (!title.isEmpty && self.titleFormatterBlock != nil){
        
            let attributedString   = self.titleFormatterBlock!(self,title,index,selected)
            size = attributedString.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        }else{
          size = CGSize.zero
        }
      
        return size
    }
    
    
    
    
    
    
    
    
    
    
}
