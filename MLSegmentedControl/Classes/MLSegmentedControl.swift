//
//  MLSegmentedControl.swift
//  MLSegmentedControl
//
//  Created by 戴明亮 on 2018/6/15.
//

import UIKit

/// 设置类型
///
/// - Text: 文本类型
/// - Images: 图片类型
/// - TextImages: 图片文本类型
public enum MLSegmentedType: Int {
    case text
    case image
    case textImage
}

/// 标题宽度：固定/动态
///
/// - Fixed: 固定
/// - Dynamic: 动态
public enum MLSegmentedWidthStyle: Int {
    case fixed
    case dynamic
}


/// 选中样式
///
/// - TextWidthStripe: 线条和文字宽度相等
/// - FullWidthStripe: 填充整个segment
/// - SelectionStyleBox: Box样式
/// - SelectionStyleArrow: 箭头样式
public enum MLSegmentedSelectionStyle:Int {
    // 线条的宽度和文本size相等
    case textWidthStripe
    // 线条和item相等
    case fullWidthStripe
    // 填充整个item
    case selectionStyleBox
    // 选中箭头样式
    case selectionStyleArrow
}


/// 选中线条位置
///
/// - Up: 在文字上方显示
/// - Down: 在文字下方显示
/// - None: No
public enum MLSegmentedSelectionIndicatorLocation:Int {
    case up
    case down
    case none
}




/// 边缘线条位置
public struct MLSegmentedBorderType:OptionSet {
    
    public var rawValue: Int = 0
    public  static let none = MLSegmentedBorderType(rawValue: 0) // 000000
    
    public  static let top = MLSegmentedBorderType(rawValue: 1 << 0) // 000001
    
    public  static let bottom = MLSegmentedBorderType(rawValue: 1 << 1) // 000010
    
    public static let left = MLSegmentedBorderType(rawValue: 1 << 2)// 000100
    
    public static let right = MLSegmentedBorderType(rawValue: 1 << 3)// 001000
    
    public init(rawValue:Int){
        
        self.rawValue = rawValue
    }
}




/// 图片位置
///
/// - BehindText: 图片在文字的后边
/// - LeftOfText: 图片在文字的左侧
/// - RightOfText: 图片在文字的右侧
/// - AboveText: 图片在文字上方
/// - BelowText: 图片在文字的下方
public enum MLSegmentedImagePosition {
    case behindText
    case leftOfText
    case rightOfText
    case aboveText
    case belowText
    
}


/// 默认选中索引
/// 如果选中索引值 NoSelectSegment 为没有选中
/// - NoSelectSegment: <#NoSelectSegment description#>
public enum MLSegmentedControlNoSegment:Int {
    case noSelectSegment = -1
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
    
  public typealias MLTitleFormatterClosure = (_ segmentedControl:MLSegmentedControl,_ title:String,_ index:Int,_ selected:Bool)-> NSAttributedString
    
    
    public var titleFormatterClosure:MLTitleFormatterClosure?
    
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
            self.updateSegmentsRects()
            self.setNeedsDisplay()
            self.layoutIfNeeded()
        }
    }
    
    //MARK: 图片名称
   public var sectionImages:Array<UIImage>{
        didSet{
            self.setNeedsDisplay()  // 调整子视图的布局，下个周期起作用
            self.layoutIfNeeded() // 立即更新子视图
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
   public var type:MLSegmentedType = .text
    
    //MARK: 标题的宽度是固定还是动态
    public  var segmentWidthStyle:MLSegmentedWidthStyle = .fixed {
        didSet{
            if self.type == .image {
                segmentWidthStyle = .fixed
            }
        }
    }
    
    //MARK: 选中样式
   public var selectionStyle:MLSegmentedSelectionStyle = .textWidthStripe
    

    
    
    //MARK: 线条位置
    public  var selectionIndicatorLocation:MLSegmentedSelectionIndicatorLocation = .down{
        didSet{
            if selectionIndicatorLocation == .none {
                self.selectionIndicatorHeight = 0
            }
        }
    }
    
    //MARK: 图片位置
   public var imagePosition:MLSegmentedImagePosition = .aboveText

    //MARK: 当前选中索引
   public var selectedSegmentIndex = 0
    
    // MARK: segment 宽度
   public var segmentWidth:CGFloat = 0
    
    // MARK: 底部的指示线条的高度
   public var selectionIndicatorHeight:CGFloat = 1

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
    public var verticalDividerColor:UIColor = UIColor(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)
    
    /// 视图边缘线位置
    public  var borderType:MLSegmentedBorderType = .right{
        didSet{
            self.setNeedsLayout()
        }
    }
    //MARK: 视图边缘线颜色
   public var borderColor:UIColor = UIColor.black
   public var borderWidth:CGFloat = 1
    
    //MARK: 选中Segment底部线条颜色
    public var selectionIndicatorColor:UIColor = UIColor(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)

    // MARK: 选中SegmentBox背景颜色
    public var selectionIndicatorBoxColor:UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
    
    // MARK: 是否可以点击默认true
    public var touchEnabled: Bool = true
    
    
    // MARK: 普通标题设置(font,color)
    public var normalTitleTextAttributes:[NSAttributedStringKey: Any]?
    
    // MARK: 选中标题设置(font,color)
    public var selectedTitleTextAttributes:[NSAttributedStringKey: Any]?
    
    // MARK: 图片和文字的间距
    public var textImageSpacing:CGFloat = 0;
    
    // MARK: 设置box透明度
    public var selectionIndicatorBoxOpacity:Float = 1 {
        didSet{
            self.selectionIndicatorBoxLayer.opacity = selectionIndicatorBoxOpacity
        }
    }
   // MARK: 选中是否有动画，默认true
    public var shouldAnimateSelection:Bool = true
    
    
  // MARK: 回调方法
    public typealias MLSelectionChangeToIndexClosure = (_ selectionIndex: Int) -> Void
    public var selectionChangeToIndexClosure:MLSelectionChangeToIndexClosure?
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>){
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: nil, sectionSelectImages: nil)
        
        self.type = .text
        self.sectionsTitles = sectiontitles
        
        initialize()
    }


    public convenience init(sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage> ) {
         self.init(frame: CGRect.zero, sectionsTitles: nil, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        self.type = .image
        self.sectionImages = sectionImages
        self.sectionSelectImages = selectImages
        

        initialize()
    }
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>,sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage>) {
      
        assert((sectiontitles.count == sectionImages.count) ? true : false, "sectiontitles not equal to the selectImages！")
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        
        self.type = .textImage

    }
    
    
    // 指定构造函数
    private init(frame: CGRect, sectionsTitles sectiontitles:Array<String>?,sectionForImages sectionImages:Array<UIImage>?,sectionSelectImages selectImages:Array<UIImage>?) {
     
        
        if sectiontitles != nil {
            self.sectionsTitles = sectiontitles!
        }else{
            self.sectionsTitles = Array()
        }
        
        if sectionImages != nil {
             self.sectionImages = sectionImages!
        }else{
            self.sectionImages = Array()
        }
        if selectImages != nil {
             self.sectionSelectImages = selectImages!
        }else{
            self.sectionSelectImages = Array()
        }

        super.init(frame: frame)
        defaultValue()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    // 调整视图位置
    open override var frame: CGRect{
        didSet{
            self.updateSegmentsRects()
        }
    }
    
    
    // 设置默认值
    func defaultValue(){
        self.backgroundColorSegment = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
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
    
    func sectionCount() ->Int{
    
        if self.type == .text {
            return self.sectionsTitles.count
        }else{
            return self.sectionImages.count
        }
    }
    
    // MARK: 更新视图位置
    func updateSegmentsRects(){
        
      
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        
        if self.sectionCount() > 0 {
            self.segmentWidth = self.frame.size.width  / CGFloat(self.sectionCount())
        }

        if self.type == .text && self.segmentWidthStyle == .fixed {
            for (i,_) in self.sectionsTitles.enumerated() {
                let size =  self.calculateTitleSizeAtIndex(index: i)
                let stringWidth = size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                self.segmentWidth = max(stringWidth, self.segmentWidth)
            }
          
        }else if self.type == .text && self.segmentWidthStyle == .dynamic{
    
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

        }else if self.type == .image{

            for (_, image) in self.sectionImages.enumerated() {
               let imageSizeWidth = image.size.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
                self.segmentWidth = max(imageSizeWidth, self.segmentWidth)
            }

        }else if self.type == .textImage && self.segmentWidthStyle == .fixed {

            if self.imagePosition == .leftOfText || self.imagePosition == .rightOfText{
                
                for (index, _) in self.sectionsTitles.enumerated() {
                    let  image = self.sectionImages[index];
                   let stringWidth = self.calculateTitleSizeAtIndex(index: index).width
                   let imageWidth = image.size.width
                    let totalWidth = stringWidth + imageWidth + self.textImageSpacing + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                    self.segmentWidth = max(self.segmentWidth, totalWidth)
                }

            }else{
                for (index, _) in self.sectionsTitles.enumerated() {
                    let  image = self.sectionImages[index];
                    let stringWidth = self.calculateTitleSizeAtIndex(index: index).width + self.segmentEdgeInset.left + self.segmentEdgeInset.right
                    let array = [stringWidth, self.segmentWidth,image.size.width]
                 
                    for width in array{
                      self.segmentWidth =  max(self.segmentWidth, width)
                    }
                    
//                    self.segmentWidth = max(self.segmentWidth, stringWidth)
                }
                
            }
            
        }else if self.type == .textImage && self.segmentWidthStyle == .dynamic{
            
            var mutableSegmentWidths:Array<CGFloat> = Array()
            var totalWidth:CGFloat = 0

            for (index,_) in self.sectionsTitles.enumerated(){
                
                 let image = self.sectionImages[index]
                var stringWidth:CGFloat = 0
                var imageWidth:CGFloat = 0
               
                  stringWidth = self.calculateTitleSizeAtIndex(index: index).width
                  imageWidth  = image.size.width
                
                var composeWidth:CGFloat = 0
                if self.imagePosition == .leftOfText || self.imagePosition == .rightOfText{
                     composeWidth = stringWidth + imageWidth + self.enlargeEdgeInset.right + self.segmentEdgeInset.left
                }else{
                    composeWidth = max(stringWidth, imageWidth) + self.enlargeEdgeInset.right + self.segmentEdgeInset.left
                }
                  totalWidth += composeWidth
                  mutableSegmentWidths.append(composeWidth)
            }
            

            if self.shouldStretchSegmentsToScreenSize == true && totalWidth < UIScreen.main.bounds.width{
                let margeWidth = UIScreen.main.bounds.width - totalWidth
                
                let deuceMargeWidth = CGFloat(roundf(Float(margeWidth / CGFloat(self.sectionsTitles.count))))
                
                for (i,width) in mutableSegmentWidths.enumerated(){
                    
                    let newWidth = width + deuceMargeWidth
                    
                    mutableSegmentWidths[i] = newWidth
                }
                
            }
            self.segmentWidthsArray = mutableSegmentWidths
        }

        self.scrollView.isScrollEnabled = true
        self.scrollView.contentSize = CGSize.init(width: totalSegmentedControlWidth(), height: self.frame.size.height)
        
    }
    
    // FIXME:动态标题->计算总宽度
    func totalSegmentedControlWidth() -> CGFloat {
        
        if self.segmentWidthStyle == .dynamic {
           return self.segmentWidthsArray.reduce(0) {$0 + $1}
        }else{
            return CGFloat(self.sectionsTitles.count) * self.segmentWidth;
        }

    }
    
    

    
    // MARK: 绘制方法
    override open func draw(_ rect: CGRect) {

        self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.cgColor
        self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.cgColor
        self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorBoxColor.cgColor

        // 绘制一个带有颜色的矩形
        self.backgroundColorSegment?.setFill()
        UIRectFill(self.bounds)
        
        // 每次绘制都先清空在添加视图
        self.scrollView.layer.sublayers = nil

        switch self.type {
        case .text:
            loadSegmentedControlTypeText(rect: rect)
            break
        case .image:
             loadSegmentedControltypeImage(rect: rect)
            break
        case .textImage:
            loadSegmentedControltypeTextImage(rect: rect)
            break
        }

      // 添加 其他附件视图 底部指示线/箭头/box
        self.configAttachmentView()
    }
    
    
    // MARK: 加载文本和图片类型
    func loadSegmentedControltypeTextImage(rect:CGRect){
        
        for (index, _) in self.sectionsTitles.enumerated() {
            
            let stringSize = self.calculateTitleSizeAtIndex(index: index)
            let image       = self.sectionImages[index]
            
            var stringWidth = stringSize.width
            let stringHeight = stringSize.height
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            var imageOffsetX = self.segmentWidth * CGFloat(index)
            var textOffsetX = self.segmentWidth * CGFloat(index)
            var imageOffsetY = CGFloat(ceilf(Float((self.frame.height -  imageHeight) * 0.5 )))
            var textOffsetY = CGFloat(ceilf(Float((self.frame.height -  stringHeight) * 0.5 )))
            
            // 填充
            var fullRect = CGRect.zero
            
            
            if self.segmentWidthStyle == .fixed{
                
                
                let isHorizontalShow = (self.imagePosition == .leftOfText || self.imagePosition == .rightOfText) ? true : false
                
                if isHorizontalShow == true{
                    
                    let whitespace:CGFloat = self.segmentWidth - imageWidth - self.textImageSpacing - stringWidth
                    
                    if self.imagePosition == .leftOfText{
                        imageOffsetX += CGFloat(ceilf(Float(whitespace * 0.5)))
                        textOffsetX = imageOffsetX + imageWidth + self.textImageSpacing
                         fullRect =  CGRect.init(x: imageOffsetX, y: 0, width: self.segmentWidth, height: rect.height)
                    }else{
                        textOffsetX += CGFloat(ceilf(Float(whitespace * 0.5)))
                        imageOffsetX = textOffsetX + stringWidth + self.textImageSpacing
                        fullRect =  CGRect.init(x: textOffsetX, y: 0, width: self.segmentWidth, height: rect.height)
                    }
                   
                }else{
                    
                    if self.imagePosition == .behindText{
                        
                        imageOffsetX = self.segmentWidth * CGFloat(index) + (self.segmentWidth - imageWidth) * 0.5
                        textOffsetX = self.segmentWidth * CGFloat(index) + (self.segmentWidth - stringWidth) * 0.5
                        
                    }else{
                        imageOffsetX = self.segmentWidth * CGFloat(index) + (self.segmentWidth - imageWidth) * 0.5
                        textOffsetX = self.segmentWidth * CGFloat(index) + (self.segmentWidth - stringWidth) * 0.5
                        let whitespace:CGFloat = self.frame.height - imageHeight - self.textImageSpacing - stringHeight
                        if self.imagePosition == .aboveText{
                            
                            imageOffsetY =  CGFloat(ceilf(Float(whitespace * 0.5)))
                            textOffsetY = imageOffsetY + imageHeight + self.textImageSpacing
                            
                        }else{
                            textOffsetY = CGFloat(ceilf(Float(whitespace * 0.5)))
                            imageOffsetY = textOffsetY + stringHeight + self.textImageSpacing
                        }

                    }
                      fullRect =  CGRect.init(x: imageOffsetX, y: 0, width: self.segmentWidth, height: rect.height)

                }
                
            }else{
                
                 let isHorizontalShow = (self.imagePosition == .leftOfText || self.imagePosition == .rightOfText) ? true : false
                
                var offsetX:CGFloat = 0
                var currentIndex:Int = 0
                
                for (i, width) in self.segmentWidthsArray.enumerated(){
                    currentIndex = i;
                    if index == i {break}
                    offsetX  += width
                }
                if isHorizontalShow == true{
  
                    if self.imagePosition == .leftOfText{
                        imageOffsetX = offsetX
                        textOffsetX  = offsetX + imageWidth + self.textImageSpacing
                        
                    }else{
                        textOffsetX = offsetX
                        imageOffsetX = offsetX + stringWidth + self.textImageSpacing
                    }
                    
                     fullRect =  CGRect.init(x: imageOffsetX, y: 0, width: imageWidth + stringWidth + self.textImageSpacing, height: rect.height)
                }else{
                    
                    
                    if self.imagePosition == .behindText{


                        imageOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - imageWidth) * 0.5
                        textOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - stringWidth) * 0.5
                        // stringWidth 这里的宽度是文本的实际宽度，如果是动态加载应该取self.segmentWidthsArray这里面的宽度
                        stringWidth = self.segmentWidthsArray[currentIndex]
                    }else{
                        imageOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - imageWidth) * 0.5
                        textOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - stringWidth) * 0.5
                        // stringWidth 这里的宽度是文本的实际宽度，如果是动态加载应该取self.segmentWidthsArray这里面的宽度
                        stringWidth = self.segmentWidthsArray[currentIndex]
                        let whiteSpace = self.frame.height - imageHeight - self.textImageSpacing - stringHeight
                        if self.imagePosition == .aboveText{
                            imageOffsetY =  CGFloat(ceilf(Float(whiteSpace * 0.5)))
                            textOffsetY = imageOffsetY + imageHeight + self.textImageSpacing
                        }else{
                            textOffsetY = CGFloat(ceilf(Float(whiteSpace * 0.5)))
                            imageOffsetY = textOffsetY + stringHeight + self.textImageSpacing
                        }

                    }
                     fullRect =  CGRect.init(x: imageOffsetX, y: 0, width: max(imageOffsetX, textOffsetX), height: rect.height)
                }

            }
            
            
            let imageRect = CGRect(x: imageOffsetX, y: imageOffsetY, width: imageWidth, height: imageHeight)
            
            let textRect = CGRect(x: textOffsetX, y: textOffsetY, width: stringWidth, height: stringHeight)
            
            
            
             let titleLayer = CATextLayer()
            titleLayer.frame = textRect
            titleLayer.string = self.textLayerAttributedStringForIndex(index: index)
            titleLayer.contentsScale = UIScreen.main.scale
            titleLayer.alignmentMode = kCAAlignmentCenter
            self.scrollView.layer.addSublayer(titleLayer)
            
            let imageLayer = CALayer()
            let selected = self.selectedSegmentIndex == index ? true : false
            if selected == true{
                imageLayer.contents = self.sectionSelectImages[index].cgImage
            }else{
                imageLayer.contents = self.sectionImages[index].cgImage
            }
            
            imageLayer.frame = imageRect
            self.scrollView.layer.addSublayer(imageLayer)
            
            self.addBackgroundAndBorderLayerWithRect(rect: fullRect)
            
        }
        
        
        
    }
    
    
    
    
    // MARK: 加载图片类型
    func loadSegmentedControltypeImage(rect:CGRect){
        
        
        for (index, image) in self.sectionImages.enumerated() {
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let locationUp = self.selectionIndicatorLocation == .up
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.height - self.selectionIndicatorHeight)  * 0.5 - imageHeight * 0.5 + locationUpValue * selectionIndicatorHeight
            
            let x = self.segmentWidth * CGFloat(index) + (self.segmentWidth - imageWidth) * 0.5
            
            
            
            let resultRect = CGRect(x: x, y: y, width: imageWidth, height: imageHeight)
            let rectDiv:CGRect = CGRect(x: (self.segmentWidth * CGFloat(index)) - self.verticalDividerWidth * 0.5, y: y, width: self.verticalDividerWidth, height: imageHeight)
            
            let imageLayer = CALayer()
            imageLayer.frame = resultRect
            
            if self.sectionSelectImages.count > 0{
                if self.selectedSegmentIndex == index {
                    let selectImage = self.sectionSelectImages[index]
                    imageLayer.contents = selectImage.cgImage
                }else{
                    imageLayer.contents = image.cgImage
                }
            }else{
                imageLayer.contents = image.cgImage
            }
            
            
            
            self.scrollView.layer.addSublayer(imageLayer)
            
            // 添加分割线
            if self.verticalDividerEnabled == true && index > 0{
                let verticalDividerLayer = CALayer.init()
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.cgColor
                verticalDividerLayer.frame = rectDiv
                self.scrollView.layer.addSublayer(verticalDividerLayer)
            }
            
            self.addBackgroundAndBorderLayerWithRect(rect: resultRect)
            
        }

    }
    
    
    
    
    
    
    // MARK: 加载文本类型
    func loadSegmentedControlTypeText(rect:CGRect){
    
    
        for (i, _) in self.sectionsTitles.enumerated() {
   
            var stringWidth:CGFloat = 0;
            var stringHeight:CGFloat = 0;
            let size = self .calculateTitleSizeAtIndex(index: i)
            stringWidth = size.width
            stringHeight = size.height
            
            var rectDiv:CGRect = CGRect.zero
            var fullRect:CGRect = CGRect.zero
            
      
            let locationUp:Bool = self.selectionIndicatorLocation == .up ? true : false
            
            // 非选中Box样式
            let selectionStyleNotBox = self.selectionStyle != .selectionStyleBox ? true : false
            
            
            let notBoxValue = CGFloat(selectionStyleNotBox.hashValue)
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.size.height - notBoxValue * self.selectionIndicatorHeight) * 0.5 - stringHeight * 0.5 + locationUpValue * self.selectionIndicatorHeight
            
          
            var rectReslut:CGRect = CGRect.zero
            if segmentWidthStyle == .fixed { // 固定宽度
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
            titleLayer.string = self.textLayerAttributedStringForIndex(index: i);
            titleLayer.frame = rectReslut
            titleLayer.contentsScale = UIScreen.main.scale
            titleLayer.alignmentMode = kCAAlignmentCenter
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
        
        if (!title.isEmpty && self.titleFormatterClosure == nil) {
            
            let title:NSString = title as NSString
            size =  title.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: selected ?self.resultingSelectedTitleTextAttributes():self.resultingTitleTextAttributes(), context: nil).size
 
        }else if (!title.isEmpty && self.titleFormatterClosure != nil){
        
            let attributedString   = self.titleFormatterClosure!(self,title,index,selected)
            size = attributedString.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        }else{
          size = CGSize.zero
        }
      
        return size
    }
    
    
    
    //MARK: 转换AttributedString
    func textLayerAttributedStringForIndex(index:Int) -> NSAttributedString{
       
        
        let selected:Bool = self.selectedSegmentIndex == index ?true :false
        
        
         let title = self.sectionsTitles[index]
        
        var attributes:[NSAttributedStringKey:Any]? = nil
        if selected == true {
             attributes = self.resultingSelectedTitleTextAttributes()
        }else{
             attributes = self.resultingTitleTextAttributes()
        }

        if (!title.isEmpty && self.titleFormatterClosure == nil) {
             return   NSAttributedString.init(string: title, attributes:attributes)
        }else if (!title.isEmpty && self.titleFormatterClosure != nil){
            return self.titleFormatterClosure!(self,title,index,selected)
        }else{
            return   NSAttributedString.init(string: title, attributes:attributes)
        }

    }
    
    
    
    // MARK:默认标题设置
    func resultingTitleTextAttributes() -> [NSAttributedStringKey:Any] {
        
        var defaultDicts:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)]
        if let normalAttributes = self.normalTitleTextAttributes {
           defaultDicts = defaultDicts.merging(normalAttributes) { (_,new) in new}
        }
          return defaultDicts
    }
    
    // MARK:选中标题设置
    func resultingSelectedTitleTextAttributes() -> [NSAttributedStringKey:Any] {
        var selectDicts:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.init(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)]

        if let selectedAttributes = self.selectedTitleTextAttributes {
            
           selectDicts = selectDicts.merging(selectedAttributes) { (_, new) in new}
        }
        return selectDicts
    }
    
    
    
    // MARK:配置附件视图（底部指示线/箭头/Box）
    func configAttachmentView(){
        if self.selectedSegmentIndex != MLSegmentedControlNoSegment.noSelectSegment.rawValue {
            
            if self.selectionStyle == .selectionStyleArrow{
                if self.selectionIndicatorArrowLayer.superlayer == nil {
                    
                    self.scrollView.layer.addSublayer(self.selectionIndicatorArrowLayer)
                    self.setArrowFrame()
                    
                }
            }else{
                if self.selectionIndicatorStripLayer.superlayer == nil {
                    
                    self.scrollView.layer.addSublayer(self.selectionIndicatorStripLayer)
                    self.selectionIndicatorStripLayer.frame = self.frameForSelectionIndicator()
                    
                    if self.selectionStyle == .selectionStyleBox && self.selectionIndicatorBoxLayer.superlayer == nil{
                        
                        self.scrollView.layer.insertSublayer(self.selectionIndicatorBoxLayer, at: 0)
                        self.selectionIndicatorBoxLayer.frame = self.frameForFillerSelectionIndicator()
                    }
                    
                }
            }
            
        }
    }
    
    
    
    
    /// MARK:添加边缘线条
    func addBackgroundAndBorderLayerWithRect(rect:CGRect){
        
        // add backgroundLayer
        let backgroundLayer = CALayer.init()
        backgroundLayer.frame = rect
        self.layer.insertSublayer(backgroundLayer, at: 0)
        
        // add borderLayer
        if self.borderType == .top {
            
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: self.borderWidth)
            borderLayer.backgroundColor = UIColor.orange.cgColor
                //self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
            
            
        }else if self.borderType == .bottom{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: rect.height, width: rect.width, height: self.borderWidth)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
            
        }else if self.borderType == .left{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.borderWidth, height: rect.height)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
        }else if self.borderType == .right{
            let borderLayer = CALayer.init()
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.borderWidth, height: rect.height)
            borderLayer.backgroundColor = self.borderColor.cgColor
            backgroundLayer.addSublayer(borderLayer)
        }
    }
    
    
    // MARK:计算地图视图选中位置
    func frameForSelectionIndicator() -> CGRect {
        
        var indicatorYOffset:CGFloat = 0
        
        if self.selectionIndicatorLocation == .up {
            indicatorYOffset = self.selectionIndicatorEdgeInsets.top
        }
    
        if  self.selectionIndicatorLocation == .down {
           indicatorYOffset = self.frame.height - self.selectionIndicatorHeight + self.selectionIndicatorEdgeInsets.bottom
        }
        
        
        var sectionWidth: CGFloat = 0

        if self.type == .text {
            sectionWidth = self.calculateTitleSizeAtIndex(index: self.selectedSegmentIndex).width
        }else if self.type == .image {
             let  image = self.sectionImages[self.selectedSegmentIndex]
            sectionWidth = image.size.width
        }else {
            
          let stringSize =  self.calculateTitleSizeAtIndex(index: self.selectedSegmentIndex)
          let image = self.sectionImages[self.selectedSegmentIndex]
        
            if self.imagePosition == .leftOfText || self.imagePosition == .rightOfText{
                 sectionWidth = max(stringSize.width + self.textImageSpacing + image.size.width, image.size.width)
            }else{
                
                 sectionWidth = max(max(stringSize.width, image.size.width), image.size.width)
            }
           
            
        }

        if self.selectionStyle == .selectionStyleArrow {
            

            if self.segmentWidthStyle == .dynamic && sectionWidth <= self.segmentWidth{
                var offsetX:CGFloat = 0
                for (i, width) in self.segmentWidthsArray.enumerated() {
                    if self.selectedSegmentIndex == i {break}
                    offsetX += width
                }
                // FIXME:self.selectedSegmentIndex 这个宽度 最好使用 上面的for循环里面的可以记录当前宽度
                return CGRect(x: offsetX + (self.segmentWidthsArray[self.selectedSegmentIndex] * 0.5 - self.selectionIndicatorHeight) , y: indicatorYOffset, width: self.selectionIndicatorHeight * 2, height: self.selectionIndicatorHeight)
                
            }else{
                let widthToStatrtOfSelectedSegment = self.segmentWidth * CGFloat(self.selectedSegmentIndex)
                let widthToEndOfSelectedSegment =  self.segmentWidth * CGFloat(self.selectedSegmentIndex) + self.segmentWidth
                
                let x = (widthToEndOfSelectedSegment - widthToStatrtOfSelectedSegment) * 0.5 + widthToStatrtOfSelectedSegment - self.selectionIndicatorHeight * 0.5
                return CGRect(x: x, y: indicatorYOffset, width: self.selectionIndicatorHeight * 2, height: self.selectionIndicatorHeight)
            }
            
        }else{
            
            
            /** 三个条件x
            条件一： self.selectionStyle == .MLSegmentedControlSelectionStyleTextWidthStripe：指示线和标题宽度一样
            条件二： 标题宽度必须是固定的 即 MLSegmentedControlSegmentWidthStyleFixed
            条件三： sectionWidth <= self.segmentWidth 如果 sectionWidth >  self.segmentWidth 说明标题一定是动态计算宽度的
             
             */
            if self.selectionStyle == .textWidthStripe && self.segmentWidthStyle == .fixed && sectionWidth <= self.segmentWidth{
                let widthToStatrtOfSelectedSegment = self.segmentWidth * CGFloat(self.selectedSegmentIndex)
                let widthToEndOfSelectedSegment =  self.segmentWidth * CGFloat(self.selectedSegmentIndex) + self.segmentWidth
                
                let x = (widthToEndOfSelectedSegment - widthToStatrtOfSelectedSegment) * 0.5 + widthToStatrtOfSelectedSegment - sectionWidth * 0.5 + self.selectionIndicatorEdgeInsets.left
                
                return CGRect(x: x, y: indicatorYOffset, width: sectionWidth - self.selectionIndicatorEdgeInsets.right, height: self.selectionIndicatorHeight)
                
            }else{

                if self.segmentWidthStyle == .dynamic{
                    
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
        
        if self.selectionIndicatorLocation == .up{
         pointOne = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width * 0.5, y: self.selectionIndicatorArrowLayer.frame.height)
         pointTwo = CGPoint(x: self.selectionIndicatorArrowLayer.frame.width, y: 0)
         pointThree = CGPoint(x: 0, y: 0)
        }
        
        
        if self.selectionIndicatorLocation == .down{
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

        if self.segmentWidthStyle == .dynamic {
            
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
            
            if self.segmentWidthStyle == .fixed {
                segmentIndex = Int((touchLoaction.x + self.scrollView.contentOffset.x) / self.segmentWidth)
            }else if self.segmentWidthStyle == .dynamic{
                
                var dis = touchLoaction.x + self.scrollView.contentOffset.x
                for (_,width) in self.segmentWidthsArray.enumerated(){
                    dis -= width
                    if dis < 0 {break}
                     segmentIndex += 1
                    
                }

            }
            
            
            var sectionsCount:Int = 0
            if self.type == .text || self.type == .textImage{
                sectionsCount = self.sectionsTitles.count
            }else if self.type == .image{
                sectionsCount = self.sectionImages.count
            }
            
            if segmentIndex != self.selectedSegmentIndex && segmentIndex < sectionsCount{
                if self.touchEnabled == true{
                    self.setSelectedSegmentIndex(index: segmentIndex, animation: self.shouldAnimateSelection, notify: true)
                }
            }
            
            
        }
        
    }
    
    
    // MARK: Index Change
    
    //MARK: 设置索引
    
    func setSelectedSegmentIndex(index:Int){
        self.setSelectedSegmentIndex(index: index, animation: false, notify: false)
    }
    
    func setSelectedSegmentIndex(index:Int,animation:Bool){
        self.setSelectedSegmentIndex(index: index, animation: animation, notify: false)
    }
    
    func setSelectedSegmentIndex(index:Int,animation:Bool,notify:Bool){
        self.selectedSegmentIndex = index
        self.setNeedsDisplay()
        if index == MLSegmentedControlNoSegment.noSelectSegment.rawValue {
            self.selectionIndicatorStripLayer.removeFromSuperlayer()
            self.selectionIndicatorBoxLayer.removeFromSuperlayer()
            self.selectionIndicatorArrowLayer.removeFromSuperlayer()
        }else{
            self.scrollToSelectedSegmentIndex(animation: animation)
            
            if animation == true {

                if self.selectionStyle == .selectionStyleArrow{
                    if self.selectionIndicatorArrowLayer.superlayer == nil {
                        self.scrollView.layer.addSublayer(self.selectionIndicatorArrowLayer)
                        self.setSelectedSegmentIndex(index: index, animation: false, notify: false)
                        return
                    }
                }else{
                    
                    if self.selectionIndicatorStripLayer.superlayer == nil {
                        self.scrollView.layer.addSublayer(self.selectionIndicatorStripLayer)
                        self.setSelectedSegmentIndex(index: index, animation: false, notify: false)
                        return
                    }
                    
                    if selectionStyle == .selectionStyleBox {
                        if self.selectionIndicatorBoxLayer.superlayer == nil{
                            self.scrollView.layer.insertSublayer(self.selectionIndicatorBoxLayer, at: 0)
                            self.setSelectedSegmentIndex(index: index, animation: false, notify: false)
                            return
                        }
                       
                    }

                }
                
                // 还原/恢复隐式动画
                self.selectionIndicatorStripLayer.actions = nil
                self.selectionIndicatorArrowLayer.actions = nil
                self.selectionIndicatorBoxLayer.actions = nil
                
                
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.4)
                // 线性动画，渐出动画
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
                self.selectionIndicatorStripLayer.frame = self.frameForSelectionIndicator()
                self.setArrowFrame()
                selectionIndicatorBoxLayer.frame = self.frameForFillerSelectionIndicator()
                CATransaction.commit()
   
            }else{
                
                // 禁用隐式动画，防止系统使用默认的方法执行动画
                let actions = ["postion":NSNull(),"bounds":NSNull()]
                self.selectionIndicatorBoxLayer.actions = actions
                self.selectionIndicatorArrowLayer.actions = actions
                self.selectionIndicatorStripLayer.actions = actions
                self.selectionIndicatorStripLayer.frame = self.frameForSelectionIndicator()
                self.setArrowFrame()
                selectionIndicatorBoxLayer.frame = self.frameForFillerSelectionIndicator()
                
            }
            
            
            if notify == true{
             self.notifySegmentChangeToIndex(index: index)
            }

        }
    }
    
    
    func notifySegmentChangeToIndex(index:Int){
        if superview != nil {
            self.sendActions(for: [.valueChanged])
        }
        if selectionChangeToIndexClosure != nil{
            self.selectionChangeToIndexClosure!(index)
        }
  
    }
    
   
    // MARK:滚动到指定的位置
    func scrollToSelectedSegmentIndex(animation:Bool){
        var rectForSelectedIndex:CGRect = CGRect.zero
        var selectedSegmentOffset: CGFloat = 0
        
        if self.segmentWidthStyle == .fixed {
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
