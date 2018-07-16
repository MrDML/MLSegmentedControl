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




/// 边缘线条位置
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


/// 默认选中索引
/// 如果选中索引值 NoSelectSegment 为没有选中
/// - NoSelectSegment: <#NoSelectSegment description#>
public enum MLSegmentedControlNoSegment:Int {
    case NoSelectSegment = -1
}


class MLScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging == false {
            self.next?.touchesBegan(touches, with: event)
        }else{
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging == false {
            self.next?.touchesMoved(touches, with: event)
        }else{
            super.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isDragging == false {
            self.next?.touchesEnded(touches, with: event)
        }else{
            super.touchesEnded(touches, with: event)
        }
    }
    
}




open class MLSegmentedControl: UIControl {

    
    lazy var scrollView: MLScrollView = {
        let scr = MLScrollView.init()
        scr.scrollsToTop = false
        scr.showsVerticalScrollIndicator = false
        scr.showsHorizontalScrollIndicator = false
        return scr
    }()
    
    typealias MLTitleFormatterBlock = (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool)-> NSAttributedString
    
    
     var titleFormatterBlock:MLTitleFormatterBlock?
    
    //MARK: 条状线条指示器
    lazy var selectionIndicatorStripLayer: CALayer = {
        let stripLayer = CALayer()
        return stripLayer
        
    }()
    
    //MARK: 箭头指示器
    lazy var selectionIndicatorArrowLayer: CALayer = {
        let arrowLayer  = CALayer()
        return arrowLayer
    }()
    
    //MARK: 矩形盒指示器
    lazy var selectionIndicatorBoxLayer: CALayer = {
        let  boxLayer  = CALayer()
        return boxLayer
    }()
    
    
    
    //MARK: 标题数组
   public var sectionsTitles:Array<String>{
        didSet{
           // TODO:do somthing
        }
    }
    
    //MARK: 图片名称
   public var sectionImages:Array<UIImage>{
        didSet{
            // TODO:do somthing
        }
    }
    
    //MARK: 选中图片名称
   public var sectionSelectImages:Array<UIImage>{
        didSet{
            // TODO:do somthing
        }
    }
    

    
    //MARK: 视图背景颜色
   public var backgroundColorSegment:UIColor?
    
    
    //MARK: 展现类型
   public var type:MLSegmentedControlType = .MLSegmentedControlTypeText
    
    //MARK: 标题的宽度是固定还是动态
  public  var segmentWidthStyle:MLSegmentedControlSegmentWidthStyle = .MLSegmentedControlSegmentWidthStyleFixed
    
    //MARK: 选中样式
   public var selectionStyle:MLSegmentedControlSelectionStyle = MLSegmentedControlSelectionStyle.MLSegmentedControlSelectionStyleTextWidthStripe
    
    /// <#Description#>
  public  var borderType:MLSegmentedControlBorderType = MLSegmentedControlBorderType.Top
    
    
    //MARK: 线条位置
  public  var selectionIndicatorLocation:MLSegmentedControlSelectionIndicatorLocation = .MLSegmentedControlSelectionIndicatorLocationDown
    
    //MARK: 图片位置
   public var imagePosition:MLSegmentedControlImagePosition = MLSegmentedControlImagePosition.MLSegmentedControlImagePositionAboveText

    //MARK: 当前选中索引
   public var selectedSegmentIndex = 0
    
    // MARK: segment 宽度
   public var segmentWidth:CGFloat = 0
    
    // MARK: 底部的指示线条的高度
   public var selectionIndicatorHeight:CGFloat = 5

    // MARK: segment 宽度数组
    lazy var segmentWidthsArray:Array<CGFloat> = {
        let array = Array<CGFloat>()
        return array
    }()
    
    
    // MARK: 是否填充整个屏幕
   public var shouldStretchSegmentsToScreenSize:Bool = false
    
    // MARK: 预留参数，微调标题位置
   public var segmentEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)

    // MARK: 预留参数 放大点击区域
   public var enlargeEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    // MARK: 预留参数 扩展选中线条的具体位置
    public var selectionIndicatorEdgeInsets:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    
    ///  垂直分割线
    
    ///MARK: 是否显示分割线
   public var verticalDividerEnabled:Bool = true
    
    //MARK: 分割线宽
   public var verticalDividerWidth:CGFloat = 1
    
    //MARK: 分割线的颜色
   public var verticalDividerColor:UIColor = UIColor.black
    
    //MARK: 视图边缘线颜色
   public var borderColor:UIColor = UIColor.black
   public var borderWidth:CGFloat = 1
    
    //MARK: 选中Segment底部线条颜色
    public var selectionIndicatorColor:UIColor = UIColor(red: 52.0/255.0, green: 181.0/255.0, blue: 229.0/255.0, alpha: 1)

    // MARK: 选中SegmentBox背景颜色
    public var selectionIndicatorBoxColor:UIColor = UIColor(red: 52.0/255.0, green: 181.0/255.0, blue: 229.0/255.0, alpha: 1)
    
    // MARK: 是否可以点击默认true
    public var touchEnabled: Bool = true
    
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>){
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: nil, sectionSelectImages: nil)
        
        self.type = .MLSegmentedControlTypeText
        self.sectionsTitles = sectiontitles
        
        initialize()
    }

    
    
    
    
    
    public convenience init(sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage> ) {
         self.init(frame: CGRect.zero, sectionsTitles: nil, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        self.type = .MLSegmentedControlTypeImages
        self.sectionImages = sectionImages
        self.sectionSelectImages = selectImages
        

        initialize()
    }
    
    
    public convenience init?(sectionsTitles sectiontitles:Array<String>,sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage>) {
        if sectiontitles.count != selectImages.count {
            return nil;
        }
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        
        self.type = .MLSegmentedControlTypeTextImages

    }
    
    
    // 指定构造函数
    private init(frame: CGRect, sectionsTitles sectiontitles:Array<String>?,sectionForImages sectionImages:Array<UIImage>?,sectionSelectImages selectImages:Array<UIImage>?) {
     
        
        if sectiontitles != nil {
            self.sectionsTitles = sectiontitles!
        }else{
            self.sectionsTitles = Array.init(repeating: String(), count: 1)
        }
        
        if sectionImages != nil {
             self.sectionImages = sectionImages!
        }else{
            self.sectionImages = Array.init(repeating: UIImage(), count: 1)
        }
        if selectImages != nil {
             self.sectionSelectImages = selectImages!
        }else{
            self.sectionSelectImages = Array.init(repeating: UIImage(), count: 1)
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

    // MARK:布局子视图方法
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
    
    // MARK: 更新视图位置
    func updateSegmentsRects(){
        
      
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        if self.sectionsTitles.count > 0 {
            self.segmentWidth = self.frame.size.width  / CGFloat(self.sectionsTitles.count)
        }
        
        
        
        if self.type == .MLSegmentedControlTypeText && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed {
            for (i,title) in self.sectionsTitles.enumerated() {
                print("index:\(i) title:\(title)")
                let size =  self.calculateTitleSizeAtIndex(index: i)
                let stringWidth = size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                self.segmentWidth = max(stringWidth, self.segmentWidth)
            }
          
        }else if self.type == .MLSegmentedControlTypeText && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic{
    
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

        }else if self.type == .MLSegmentedControlTypeImages{
            
            // TODO:do somthing
            
        }else if self.type == .MLSegmentedControlTypeImages && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed{
            
            // TODO:do somthing
            
        }else if self.type == .MLSegmentedControlTypeTextImages && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic{
            
            
            // TODO:do somthing
        }

        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize.init(width: totalSegmentedControlWidth(), height: self.frame.size.height)
        
    }
    
    // FIXME:动态标题->计算总宽度
    func totalSegmentedControlWidth() -> CGFloat {
        
        if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic {
            
           return self.segmentWidthsArray.reduce(0) {$0 + $1}
            // FIXME:闭包计算总长度的写法 删
//         return self.segmentWidthsArray.reduce(0) { (a, b) -> CGFloat in
//                return a + b
//            }
        }else{
            return CGFloat(self.sectionsTitles.count) * self.segmentWidth;
        }

    }
    
    

    
    // MARK: 绘制方法
    override open func draw(_ rect: CGRect) {

        self.selectionIndicatorStripLayer.backgroundColor = UIColor.blue.cgColor
            //self.selectionIndicatorColor.cgColor
        self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.cgColor
        self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorBoxColor.cgColor

        // 绘制一个带有颜色的矩形
        self.backgroundColorSegment?.setFill()
        UIRectFill(self.bounds)
        
        // 每次绘制都先清空在添加视图
        self.scrollView.layer.sublayers = nil

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
        
       
      // 添加 其他附件视图
       
        if self.selectedSegmentIndex != MLSegmentedControlNoSegment.NoSelectSegment.rawValue {

            if self.selectionIndicatorStripLayer.superlayer == nil {
               
                self.scrollView.layer.addSublayer(self.selectionIndicatorStripLayer)
                self.selectionIndicatorStripLayer.frame = self.frameForSelectionIndicator()
                
                if self.selectionStyle == .MLHMSegmentedControlSelectionStyleBox && self.selectionIndicatorBoxLayer.superlayer == nil{
                    
                    self.scrollView.layer.insertSublayer(self.selectionIndicatorBoxLayer, at: 0)
                    self.selectionIndicatorBoxLayer.frame = self.frameForFillerSelectionIndicator()
                }
                
                
            }else if self.selectionIndicatorArrowLayer.superlayer == nil {
            
                self.scrollView.layer.addSublayer(self.selectionIndicatorArrowLayer)
                self.setArrowFrame()
  
            }

        }
    }
    
    
    
    /// 加载文本类型
    func loadSegmentedControlTypeText(rect:CGRect){
    
    
        for (i, _) in self.sectionsTitles.enumerated() {
   
            var stringWidth:CGFloat = 0;
            var stringHeight:CGFloat = 0;
            let size = self .calculateTitleSizeAtIndex(index: i)
            stringWidth = size.width
            stringHeight = size.height
            
            var rectDiv:CGRect = CGRect.zero
            var fullRect:CGRect = CGRect.zero
            
      
            let locationUp:Bool = self.selectionIndicatorLocation == .MLSegmentedControlSelectionIndicatorLocationUp ? true : false
            
            // 非选中Box样式
            let selectionStyleNotBox = self.selectionStyle != .MLHMSegmentedControlSelectionStyleBox ? true : false
            
            
            let notBoxValue = CGFloat(selectionStyleNotBox.hashValue)
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.size.height - notBoxValue * self.selectionIndicatorHeight) * 0.5 - stringHeight * 0.5 + locationUpValue * self.selectionIndicatorHeight
            
          
            var rectReslut:CGRect = CGRect.zero
            if segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed { // 固定宽度
                let x = self.segmentWidth * CGFloat(i) + (self.segmentWidth - stringWidth) * 0.5
                

                rectReslut = CGRect.init(x: x, y: y, width: stringWidth, height: stringHeight)

                // 分割线位置
                rectDiv = CGRect.init(x:  self.segmentWidth * CGFloat(i) - self.verticalDividerWidth * 0.5, y: y, width: self.verticalDividerWidth, height: stringHeight)
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
                    rectDiv = CGRect.init(x:  offset - self.verticalDividerWidth * 0.5, y: y, width: self.verticalDividerWidth, height: stringHeight)
                    // 填充 这里到底是 self.segmentWidth 还是 stringWidth 需要验证
                    fullRect = CGRect.init(x: offset, y: 0, width: stringWidth, height: rect.height)
                }
                
                
            }
            
            
            rectReslut = CGRect.init(x: CGFloat(roundf(Float(rectReslut.origin.x))), y: CGFloat(roundf(Float(rectReslut.origin.y))), width: CGFloat(roundf(Float(rectReslut.size.width))), height: CGFloat(roundf(Float(rectReslut.size.height))))
            
            rectDiv = CGRect.init(x: CGFloat(roundf(Float(rectDiv.origin.x))), y: CGFloat(roundf(Float(rectDiv.origin.y))), width: CGFloat(roundf(Float(rectDiv.size.width))), height: CGFloat(roundf(Float(rectDiv.size.height))))
            
    
            fullRect = CGRect.init(x: CGFloat(roundf(Float(fullRect.origin.x))), y: CGFloat(roundf(Float(fullRect.origin.y))), width: CGFloat(roundf(Float(fullRect.size.width))), height: CGFloat(roundf(Float(fullRect.size.height))))
            
            
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
    
    
    
    /// MARK:添加边缘线条
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
    
    
    // MARK:计算地图视图选中位置
    func frameForSelectionIndicator() -> CGRect {
        
        var indicatorYOffset:CGFloat = 0
        
        if self.selectionIndicatorLocation == .MLSegmentedControlSelectionIndicatorLocationUp {
            indicatorYOffset = self.selectionIndicatorEdgeInsets.top
        }
    
        if  self.selectionIndicatorLocation == .MLSegmentedControlSelectionIndicatorLocationDown {
           indicatorYOffset = self.frame.height - self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom
        }
        
        
        var sectionWidth: CGFloat = 0

        if self.type == .MLSegmentedControlTypeText {
            sectionWidth = self.calculateTitleSizeAtIndex(index: self.selectedSegmentIndex).width
        }else if self.type == .MLSegmentedControlTypeImages {
             let  image = self.sectionImages[self.selectedSegmentIndex]
            sectionWidth = image.size.width
        }else {
            
          let size =  self.calculateTitleSizeAtIndex(index: self.selectedSegmentIndex)
          let image = self.sectionImages[self.selectedSegmentIndex]
            sectionWidth = max(size.width, image.size.width)
            
        }

        if self.selectionStyle == .MLSegmentedControlSelectionStyleArrow {
            
            let widthToStatrtOfSelectedSegment = self.segmentWidth * CGFloat(self.selectedSegmentIndex)
            let widthToEndOfSelectedSegment =  self.segmentWidth * CGFloat(self.selectedSegmentIndex) + self.segmentWidth
            
          let x = (widthToEndOfSelectedSegment - widthToStatrtOfSelectedSegment) * 0.5 + widthToStatrtOfSelectedSegment - self.selectionIndicatorHeight * 0.5
            return CGRect(x: x, y: indicatorYOffset, width: self.selectionIndicatorHeight * 2, height: self.selectionIndicatorHeight)
            
        }else{
            
            
            /** 三个条件
            条件一： self.selectionStyle == .MLSegmentedControlSelectionStyleTextWidthStripe：指示线和标题宽度一样
            条件二： 标题宽度必须是固定的 即 MLSegmentedControlSegmentWidthStyleFixed
            条件三： sectionWidth <= self.segmentWidth 如果 sectionWidth >  self.segmentWidth 说明标题一定是动态计算宽度的
             
             */
            if self.selectionStyle == .MLSegmentedControlSelectionStyleTextWidthStripe && self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed && sectionWidth <= self.segmentWidth{
                let widthToStatrtOfSelectedSegment = self.segmentWidth * CGFloat(self.selectedSegmentIndex)
                let widthToEndOfSelectedSegment =  self.segmentWidth * CGFloat(self.selectedSegmentIndex) + self.segmentWidth
                
                let x = (widthToEndOfSelectedSegment - widthToStatrtOfSelectedSegment) * 0.5 + widthToStatrtOfSelectedSegment - sectionWidth * 0.5 + self.selectionIndicatorEdgeInsets.left
                
                return CGRect(x: x, y: indicatorYOffset, width: sectionWidth - self.selectionIndicatorEdgeInsets.right, height: self.selectionIndicatorHeight)
                
            }else{

                if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic{
                    
                    var offsetX:CGFloat = 0
                    for (i, width) in self.segmentWidthsArray.enumerated() {
                        if self.selectedSegmentIndex == i {break}
                        offsetX += width
                    }
                    
                    return CGRect(x: offsetX + self.selectionIndicatorEdgeInsets.left, y: indicatorYOffset, width: self.segmentWidthsArray[self.selectedSegmentIndex] - self.selectionIndicatorEdgeInsets.right, height: self.selectionIndicatorHeight)
                    
                }else{

                     return CGRect(x: (self.segmentWidth + self.selectionIndicatorEdgeInsets.left) * CGFloat(self.selectedSegmentIndex), y: indicatorYOffset, width: self.segmentWidth - self.selectionIndicatorEdgeInsets.right, height: self.selectionIndicatorHeight)
                }

            }

        }
        
    }
  
    
    // MARK:计算箭头的位置
    func setArrowFrame(){
        self.selectionIndicatorArrowLayer.frame = self.frameForSelectionIndicator()
        let arrowLayer = CAShapeLayer()
        // 获取一个矩形位置
        arrowLayer.frame = self.selectionIndicatorArrowLayer.bounds

        self.selectionIndicatorArrowLayer.mask = arrowLayer
        
        
        var pointOne:CGPoint = CGPoint.zero
        var pointTwo:CGPoint = CGPoint.zero
        var pointThree:CGPoint = CGPoint.zero
        
        if self.selectionIndicatorLocation == .MLSegmentedControlSelectionIndicatorLocationUp{
         pointOne = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width * 0.5, y: self.selectionIndicatorArrowLayer.frame.height)
         pointTwo = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width, y: 0)
         pointThree = CGPoint(x: 0, y: 0)
        }
        
        
        if self.selectionIndicatorLocation == .MLSegmentedControlSelectionIndicatorLocationDown{
            pointOne = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width * 0.5, y: 0)
            pointTwo = CGPoint(x: 0, y: self.selectionIndicatorArrowLayer.frame.height)
            pointThree = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width, y: self.selectionIndicatorArrowLayer.frame.height)
        }

        let path = UIBezierPath()
        path.move(to: pointOne)
        path.addLine(to: pointTwo)
        path.addLine(to: pointThree)
        path.close()
        
        arrowLayer.path = path.cgPath

    }
    
    
    // MARK:计算BOX位置
    func frameForFillerSelectionIndicator() -> CGRect {

        if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic {
            
            var offsetX:CGFloat = 0
            for (i, width) in self.segmentWidthsArray.enumerated() {
                if self.selectedSegmentIndex == i  {break}
                offsetX += width
            }

            return CGRect(x: offsetX, y: 0, width: self.segmentWidthsArray[self.selectedSegmentIndex], height: self.frame.height)
        }else{
            
            return CGRect(x: self.segmentWidth * CGFloat(self.selectedSegmentIndex), y: 0, width: self.segmentWidth, height: self.frame.height)
            
        }
        
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
      guard let touchLoaction = touches.first?.location(in: self) else { return }
        
        
        // 整个segementControl点击区域不是单个
      let enlargeRect = CGRect(x: self.bounds.origin.x - self.enlargeEdgeInset.left, y: self.bounds.origin.y - self.enlargeEdgeInset.top, width: self.bounds.width + self.enlargeEdgeInset.left + self.enlargeEdgeInset.right, height: self.bounds.height + self.enlargeEdgeInset.top + self.enlargeEdgeInset.bottom)
        
        var segmentIndex:Int = 0
        if enlargeRect.contains(touchLoaction){
            
            if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed {
                segmentIndex = Int((touchLoaction.x + self.scrollView.contentOffset.x) / self.segmentWidth)
            }else if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleDynamic{
                
                var dis = touchLoaction.x + self.scrollView.contentOffset.x
                for (_,width) in self.segmentWidthsArray.enumerated(){
                    dis -= width
                    if dis < 0 {break}
                     segmentIndex += 1
                    
                }

            }
            
            
            var sectionsCount:Int = 0
            if self.type == .MLSegmentedControlTypeText || self.type == .MLSegmentedControlTypeTextImages{
                sectionsCount = self.sectionsTitles.count
            }else if self.type == .MLSegmentedControlTypeImages{
                sectionsCount = self.sectionImages.count
            }
            
            if segmentIndex != self.selectedSegmentIndex && segmentIndex < sectionsCount{
                if self.touchEnabled == true{
                    self.setSelectedSegmentIndex(index: segmentIndex, animation: true, notify: true)
                }
            }
            
            
        }
        
    }
    
    
    // MARK: Index Change
    
    //MARK: 设置索引
    
    func setSelectedSegmentIndex(index:Int){
        
    }
    
    func setSelectedSegmentIndex(index:Int,animation:Bool){
        
    }
    
    func setSelectedSegmentIndex(index:Int,animation:Bool,notify:Bool){
        self.selectedSegmentIndex = index
        self.setNeedsDisplay()
        if index == MLSegmentedControlNoSegment.NoSelectSegment.rawValue {
            self.selectionIndicatorStripLayer.removeFromSuperlayer()
            self.selectionIndicatorBoxLayer.removeFromSuperlayer()
            self.selectionIndicatorArrowLayer.removeFromSuperlayer()
        }else{
            self.scrollToSelectedSegmentIndex(animation: animation)
            
           
            
            
            
            
        }
    }
    
    
   
    // MARK:滚动到指定的位置
    func scrollToSelectedSegmentIndex(animation:Bool){
        var rectForSelectedIndex:CGRect = CGRect.zero
        var selectedSegmentOffset: CGFloat = 0
        
        if self.segmentWidthStyle == .MLSegmentedControlSegmentWidthStyleFixed {
            rectForSelectedIndex = CGRect(x: self.segmentWidth * CGFloat(self.selectedSegmentIndex), y: 0, width: self.segmentWidth, height: self.frame.height)
            selectedSegmentOffset = self.frame.width * 0.5 - self.segmentWidth * 0.5
        }else{
            var offsetX:CGFloat = 0
            for(index,width) in self.segmentWidthsArray.enumerated() {
                if self.selectedSegmentIndex == index {break}
                offsetX += width
            }
            rectForSelectedIndex = CGRect(x: offsetX, y: 0, width: self.segmentWidthsArray[self.selectedSegmentIndex], height: self.frame.height)
            
            selectedSegmentOffset = self.frame.width * 0.5 - self.segmentWidthsArray[self.selectedSegmentIndex] * 0.5
        }
       
        
        var scrollRect = rectForSelectedIndex
        scrollRect.origin.x -= selectedSegmentOffset
        scrollRect.size.width += selectedSegmentOffset * 2
        self.scrollView.scrollRectToVisible(scrollRect, animated: animation)

    }
    
    
    
    


}
