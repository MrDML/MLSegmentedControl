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
public enum MLSegmentedControlType: Int {
    case MLSegmentedControlTypeText
    case MLSegmentedControlTypeImages
    case MLSegmentedControlTypeTextImages
}


///  SegmentWidth 标题是固定/动态
///
/// - MLSegmentedControlSegmentWidthStyleFixed: <#MLSegmentedControlSegmentWidthStyleFixed description#>
/// - MLSegmentedControlSegmentWidthStyleDynamic: <#MLSegmentedControlSegmentWidthStyleDynamic description#>
public enum MLSegmentedControlSegmentWidthStyle: Int {
    case MLSegmentedControlSegmentWidthStyleFixed
    case MLSegmentedControlSegmentWidthStyleDynamic
}



/// 选中样式
///
/// - MLSegmentedControlSelectionStyleTextWidthStripe: <#MLSegmentedControlSelectionStyleTextWidthStripe description#>
/// - MLSegmentedControlSelectionStyleFullWidthStripe: <#MLSegmentedControlSelectionStyleFullWidthStripe description#>
/// - MLHMSegmentedControlSelectionStyleBox: <#MLHMSegmentedControlSelectionStyleBox description#>
/// - MLSegmentedControlSelectionStyleArrow: <#MLSegmentedControlSelectionStyleArrow description#>
public enum MLSegmentedControlSelectionStyle:Int {
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
public enum MLSegmentedControlSelectionIndicatorLocation:Int {
    case MLSegmentedControlSelectionIndicatorLocationUp
    case MLSegmentedControlSelectionIndicatorLocationDown
    case MLSegmentedControlSelectionIndicatorLocationNone
}



public struct MLSegmentedControlBorderType:OptionSet {
    
    
    public var rawValue: Int = 0
    public  static let None = MLSegmentedControlBorderType(rawValue: 0) // 000000
    
    public  static let Top = MLSegmentedControlBorderType(rawValue: 1 << 0) // 000001
    
    public  static let Bottom = MLSegmentedControlBorderType(rawValue: 1 << 1) // 000010
    
    public static let Left = MLSegmentedControlBorderType(rawValue: 1 << 2)// 000100
    
    public static let Right = MLSegmentedControlBorderType(rawValue: 1 << 3)// 001000
    
    public init(rawValue:Int){
        
        self.rawValue = rawValue
    }
}

public struct MLTest {
    
}



/// 图片位置
///
/// - MLSegmentedControlImagePositionBehindText: <#MLSegmentedControlImagePositionBehindText description#>
/// - MLSegmentedControlImagePositionLeftOfText: <#MLSegmentedControlImagePositionLeftOfText description#>
/// - MLSegmentedControlImagePositionRightOfText: <#MLSegmentedControlImagePositionRightOfText description#>
/// - MLSegmentedControlImagePositionAboveText: <#MLSegmentedControlImagePositionAboveText description#>
/// - MLSegmentedControlImagePositionBelowText: <#MLSegmentedControlImagePositionBelowText description#>
public enum MLSegmentedControlImagePosition {
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
    
    /// 条状指示器
    lazy var selectionIndicatorStripLayer: CALayer = {
        let stripLayer = CALayer()
        return stripLayer
        
    }()
    
    /// 箭头指示器
    lazy var selectionIndicatorArrowLayer: CALayer = {
        let arrowLayer  = CALayer()
        return arrowLayer
    }()
    
    /// 矩形盒指示器
    lazy var selectionIndicatorBoxLayer: CALayer = {
        let  boxLayer  = CALayer()
        return boxLayer
    }()
    
    
    
    /// 标题数组
   public var sectionsTitles:Array<String>{
        didSet{
           
        }
    }
    
    /// 图片名称
   public var sectionImages:Array<String>{
        didSet{
            
        }
    }
    
    /// 选中图片名称
   public var sectionSelectImages:Array<String>{
        didSet{
            
        }
    }
    

    
    /// 视图背景颜色
   public var backgroundColorSegment:UIColor?
    
    
    /// 展现类型
   public var type:MLSegmentedControlType = .MLSegmentedControlTypeText
    
    /// 标题的宽度是固定还是动态
  public  var segmentWidthStyle:MLSegmentedControlSegmentWidthStyle = .MLSegmentedControlSegmentWidthStyleFixed
    
    /// 选中样式
   public var selectionStyle:MLSegmentedControlSelectionStyle = MLSegmentedControlSelectionStyle.MLSegmentedControlSelectionStyleTextWidthStripe
    
    /// <#Description#>
  public  var borderType:MLSegmentedControlBorderType = MLSegmentedControlBorderType.Top
    
    
    /// 线条位置
  public  var selectionIndicatorLocation:MLSegmentedControlSelectionIndicatorLocation = MLSegmentedControlSelectionIndicatorLocation.MLSegmentedControlSelectionIndicatorLocationUp
    
    /// 图片位置
   public var imagePosition:MLSegmentedControlImagePosition = MLSegmentedControlImagePosition.MLSegmentedControlImagePositionAboveText

    /// 当前选中索引
   public var selectedSegmentIndex = 0
    
    /// segment 宽度
   public var segmentWidth:CGFloat = 0
    
    /// 底部的指示线条的高度
   public var selectionIndicatorHeight:CGFloat = 0

    /// segment 宽度数组
    lazy var segmentWidthsArray:Array<CGFloat> = {
        let array = Array<CGFloat>()
        return array
    }()
    
    
    /// 是否填充整个屏幕
   public var shouldStretchSegmentsToScreenSize:Bool = false
    
    /// 预留参数，微调标题位置
   public var segmentEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)

    /// 预留参数 放大点击区域
   public var enlargeEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    
    ///  垂直分割线
    
    /// 是否显示分割线
   public var verticalDividerEnabled:Bool = true
    
    /// 分割线宽
   public var verticalDividerWidth:CGFloat = 1
    
    /// 分割线的颜色
   public var verticalDividerColor:UIColor = UIColor.black
    
    /// 视图边缘线颜色
   public var borderColor:UIColor = UIColor.black
   public var borderWidth:CGFloat = 1
    
    
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>){
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: nil, sectionSelectImages: nil)
        
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
     
        
        if sectiontitles != nil {
            self.sectionsTitles = sectiontitles!
        }else{
            self.sectionsTitles = Array.init(repeating: "", count: 1)
        }
        
        if sectionImages != nil {
             self.sectionImages = sectionImages!
        }else{
            self.sectionImages = Array.init(repeating: "", count: 1)
        }
        if selectImages != nil {
             self.sectionSelectImages = selectImages!
        }else{
            self.sectionSelectImages = Array.init(repeating: "", count: 1)
        }
        
        
        
        
       
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
        
        
        
        if self.type == MLSegmentedControlType.MLSegmentedControlTypeText && self.segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleFixed {
            for (i,title) in self.sectionsTitles.enumerated() {
                print("index:\(i) item:\(title)")
                let size =  self.calculateTitleSizeAtIndex(index: i)
                let stringWidth = size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                self.segmentWidth = max(stringWidth, self.segmentWidth)
            }
          
        }else if self.type == MLSegmentedControlType.MLSegmentedControlTypeText && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic{
    
            var mutableSegmentWidths:Array<CGFloat> = Array()
            var totalWidth:CGFloat = 0
            for (i, _) in self.sectionsTitles.enumerated() {
               let size = self.calculateTitleSizeAtIndex(index: i)
             
                let stringWidth = size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                totalWidth += stringWidth
                mutableSegmentWidths.append(stringWidth)
            }
            
            
         // 动态计算后 总长度有可能小于屏幕的宽度 这里增加一个选项可以一屏幕的宽度来显示
            if self.shouldStretchSegmentsToScreenSize == true && totalWidth < UIScreen.main.bounds.width {
                
                let margeWidth = UIScreen.main.bounds.width - totalWidth
                
                let deuceMargeWidth = CGFloat(roundf(Float(margeWidth / CGFloat(self.sectionsTitles.count))))
                
                for (i,width) in mutableSegmentWidths.enumerated(){
                    
                    let newWidth = width + deuceMargeWidth
                   
                    mutableSegmentWidths[i] = newWidth
                }
            }
            self.segmentWidthsArray = mutableSegmentWidths

        }else if self.type == MLSegmentedControlType.MLSegmentedControlTypeImages{
            
            
            
        }else if self.type == MLSegmentedControlType.MLSegmentedControlTypeImages && self.segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleFixed{
            
            
            
        }else if self.type == MLSegmentedControlType.MLSegmentedControlTypeTextImages && self.segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleDynamic{
            
            
            
        }
        
        
        
        
        
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize.init(width: totalSegmentedControlWidth(), height: self.frame.size.height)
        
    }
    
 
    func totalSegmentedControlWidth() -> CGFloat {
        
        if self.segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleDynamic {
            
           return self.segmentWidthsArray.reduce(0) {$0 + $1}
//         return self.segmentWidthsArray.reduce(0) { (a, b) -> CGFloat in
//                return a + b
//            }
        }else{
            return CGFloat(self.sectionsTitles.count) * self.segmentWidth;
        }

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
    
    
        for (i, _) in self.sectionsTitles.enumerated() {
   
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
            
            
            let notBoxValue = CGFloat(selectionStyleNotBox.hashValue)
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.size.height - notBoxValue * self.selectionIndicatorHeight) * 0.5 - stringHeight * 0.5 + locationUpValue * self.selectionIndicatorHeight
            
          
            var rectReslut:CGRect = CGRect.zero
            if segmentWidthStyle == MLSegmentedControlSegmentWidthStyle.MLSegmentedControlSegmentWidthStyleFixed { // 固定宽度
                let x = self.segmentWidth * CGFloat(i) + (self.segmentWidth - stringWidth) * 0.5
                

                rectReslut = CGRect.init(x: x, y: y, width: stringWidth, height: stringHeight)

                // 分割线位置
                rectDiv = CGRect.init(x:  self.segmentWidth * CGFloat(i) - self.verticalDividerWidth * 0.5, y: self.selectionIndicatorHeight * 2, width: self.verticalDividerWidth, height: self.frame.height - self.selectionIndicatorHeight * 4)
                // 填充
                fullRect = CGRect.init(x: self.segmentWidth * CGFloat(i), y: 0, width: self.segmentWidth, height: rect.height)
                

            }else{// 动态加载宽度

                var offset:CGFloat = 0
                for (j,width) in self.segmentWidthsArray.enumerated() {
                    if i == j {break}
                     offset += width
                }
                
                
                if self.segmentWidthsArray.count > 0{
                    let stringWidth = self.segmentWidthsArray[i]
                    
                    rectReslut = CGRect.init(x: offset, y: y, width: stringWidth, height: stringHeight)
                    
                    // 分割线位置
                    rectDiv = CGRect.init(x:  offset - self.verticalDividerWidth * 0.5, y: self.selectionIndicatorHeight * 2, width: self.verticalDividerWidth, height: self.frame.height - self.selectionIndicatorHeight * 4)
                    // 填充 这里到底是 self.segmentWidth 还是 stringWidth 需要验证
                    fullRect = CGRect.init(x: offset, y: 0, width: stringWidth, height: rect.height)
                }
                
                
            }
            
            
            rectReslut = CGRect.init(x: CGFloat(roundf(Float(rectReslut.origin.x))), y: CGFloat(roundf(Float(rectReslut.origin.y))), width: CGFloat(roundf(Float(rectReslut.size.width))), height: CGFloat(roundf(Float(rectReslut.size.height))))
            
            // 添加文字
            let titleLayer = CATextLayer.init()
            titleLayer.frame = rectReslut
            titleLayer.contentsScale = UIScreen.main.scale
            let str = NSAttributedString.init(string: self.sectionsTitles[i], attributes: [NSAttributedStringKey.foregroundColor : UIColor.blue,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)])
            titleLayer.string = str;
            titleLayer.alignmentMode = kCAAlignmentCenter
            titleLayer.backgroundColor = UIColor.yellow.cgColor
            self.scrollView.layer.addSublayer(titleLayer)
            // 添加分割线
            if self.verticalDividerEnabled == true && i > 0{
                let verticalDividerLayer = CALayer.init()
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.cgColor
                verticalDividerLayer.frame = rectDiv
                self.scrollView.layer.addSublayer(verticalDividerLayer)
            }
            
            // 填充整个布局
            self.addBackgroundAndBorderLayerWithRect(rect: fullRect)
            
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
    
    
    
    
    func addBackgroundAndBorderLayerWithRect(rect:CGRect){
        
        // add backgroundLayer
        let backgroundLayer = CALayer.init()
        backgroundLayer.frame = rect
        self.layer.insertSublayer(backgroundLayer, at: 0)
        
        // add borderLayer
        if self.borderType == .Top {
            
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: self.borderWidth)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
            
            
        }else if self.borderType == .Bottom{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: rect.height, width: rect.width, height: self.borderWidth)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
            
        }else if self.borderType == .Left{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.borderWidth, height: rect.height)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
        }else if self.borderType == .Right{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: rect.width, width: self.borderWidth, height: rect.height)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
        }
    }
    
    
  
    
    
    
    
}
