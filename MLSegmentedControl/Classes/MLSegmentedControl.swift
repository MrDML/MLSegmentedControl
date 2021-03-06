//
//  MLSegmentedControl.swift
//  MLSegmentedControl
//
//  Created by MrDML on 2018/6/15.
//

import UIKit

/// Type
///
/// - Text: TextStyle
/// - Images: ImagesStyle
/// - TextImages: TextImagesStyle
public enum MLSegmentedType: Int {
    case text
    case image
    case textImage
}

/// WidthStyle
///
/// - Fixed: FixedWidth
/// - Dynamic: DynamicWidth
public enum MLSegmentedWidthStyle: Int {
    case fixed
    case dynamic
}


/// SelectionStyle
///
/// - TextWidthStripe: TextWidthStripeStyle
/// - FullWidthStripe: FullWidthStripeStyle
/// - SelectionStyleBox: SelectionStyleBoxStyle
/// - SelectionStyleArrow: SelectionStyleArrowStyle
public enum MLSegmentedSelectionStyle:Int {
    case textWidthStripe
    case fullWidthStripe
    case selectionStyleBox
    case selectionStyleArrow
}


/// Location
///
/// - Up: Up
/// - Down: Down
/// - None: No
public enum MLSegmentedSelectionIndicatorLocation:Int {
    case up
    case down
    case none
}



/// BorderType
public struct MLSegmentedBorderType:OptionSet {
    
    public var rawValue: Int = 0
    public  static let none = MLSegmentedBorderType(rawValue: 0)
    
    public  static let top = MLSegmentedBorderType(rawValue: 1 << 0)
    
    public  static let bottom = MLSegmentedBorderType(rawValue: 1 << 1)
    
    public static let left = MLSegmentedBorderType(rawValue: 1 << 2)
    
    public static let right = MLSegmentedBorderType(rawValue: 1 << 3)
    
    public init(rawValue:Int){
        
        self.rawValue = rawValue
    }
}




/// ImagePosition
///
/// - BehindText: ImageBehindText
/// - LeftOfText: ImageLeftOfText
/// - RightOfText: ImageRightOfText
/// - AboveText: ImageAboveText
/// - BelowText: ImageBelowText
public enum MLSegmentedImagePosition {
    case behindText
    case leftOfText
    case rightOfText
    case aboveText
    case belowText
    
}



/// - NoSelectSegment: NoSelectSegment
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
    
    /// selectionIndicatorStripLayer
    lazy var selectionIndicatorStripLayer: CALayer = {
        let stripLayer = CALayer()
        return stripLayer
        
    }()
    
    /// selectionIndicatorArrowLayer
    lazy var selectionIndicatorArrowLayer: CALayer = {
        let arrowLayer  = CALayer()
        return arrowLayer
    }()
    
    /// selectionIndicatorBoxLayer
    lazy var selectionIndicatorBoxLayer: CALayer = {
        let  boxLayer  = CALayer()
        return boxLayer
    }()
    
    
    
    /// sectionsTitles
   public var sectionsTitles:Array<String>{
        didSet{
            self.updateSegmentsRects()
            self.setNeedsDisplay()
            self.layoutIfNeeded()
        }
    }
    
    /// sectionImages
   public var sectionImages:Array<UIImage>{
        didSet{
            self.updateSegmentsRects()
            self.setNeedsDisplay()
            self.layoutIfNeeded()
        }
    }
    
    /// sectionSelectImages
   public var sectionSelectImages:Array<UIImage>{
        didSet{
            // TODO:do somthing
        }
    }
    

    /// backgroundColorSegment
   public var backgroundColorSegment:UIColor? = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    
    
    /// type
   public var type:MLSegmentedType = .text
    
    /// segmentWidthStyle
    public  var segmentWidthStyle:MLSegmentedWidthStyle = .fixed {
        didSet{
            if self.type == .image {
                segmentWidthStyle = .fixed
            }
        }
    }
    
    // selectionStyle
   public var selectionStyle:MLSegmentedSelectionStyle = .textWidthStripe
    

    
    
    /// selectionIndicatorLocation
    public  var selectionIndicatorLocation:MLSegmentedSelectionIndicatorLocation = .down{
        didSet{
            if selectionIndicatorLocation == .none {
                self.selectionIndicatorHeight = 0
            }
        }
    }
    
    /// imagePosition
   public var imagePosition:MLSegmentedImagePosition = .aboveText

    /// selectedSegmentIndex
   public var selectedSegmentIndex = 0
    
    /// segmentWidth
   public var segmentWidth:CGFloat = 0
    
    /// selectionIndicatorHeight
   public var selectionIndicatorHeight:CGFloat = 1

    /// segmentWidthsArray
    lazy var segmentWidthsArray:Array<CGFloat> = {
        let array = Array<CGFloat>()
        return array
    }()
    
    
    /// shouldStretchSegmentsToScreenSize
   public var shouldStretchSegmentsToScreenSize:Bool = false
    
    /// segmentEdgeInset
   public var segmentEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)

    /// enlargeEdgeInset
   public var enlargeEdgeInset:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    /// selectionIndicatorEdgeInsets
    public var selectionIndicatorEdgeInsets:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    
    ///  垂直分割线
    
    /// verticalDividerEnabled
   public var verticalDividerEnabled:Bool = true
    
    /// verticalDividerWidth
   public var verticalDividerWidth:CGFloat = 1
    
    /// verticalDividerColor
    public var verticalDividerColor:UIColor = UIColor(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)
    
    /// borderType
    public  var borderType:MLSegmentedBorderType = .right{
        didSet{
            self.setNeedsLayout()
        }
    }
    /// borderColor
   public var borderColor:UIColor = UIColor.black
    /// borderWidth
   public var borderWidth:CGFloat = 1
    

    /// selectionIndicatorColor
    public var selectionIndicatorColor:UIColor = UIColor(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)


    /// selectionIndicatorBoxColor
    public var selectionIndicatorBoxColor:UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
    
    /// touchEnabled
    public var touchEnabled: Bool = true
    

    
    /// normalTitleTextAttributes
    public var normalTitleTextAttributes:[NSAttributedStringKey: Any]?
    
   
    /// selectedTitleTextAttributes
    public var selectedTitleTextAttributes:[NSAttributedStringKey: Any]?
    
 
    
    /// textImageSpacing
    public var textImageSpacing:CGFloat = 0;
    

    /// selectionIndicatorBoxOpacity
    public var selectionIndicatorBoxOpacity:Float = 1 {
        didSet{
            self.selectionIndicatorBoxLayer.opacity = selectionIndicatorBoxOpacity
        }
    }

    /// shouldAnimateSelection
    public var shouldAnimateSelection:Bool = true
    
    
    /// MLSelectionChangeToIndexClosure
    public typealias MLSelectionChangeToIndexClosure = (_ selectionIndex: Int) -> Void
    public var selectionChangeToIndexClosure:MLSelectionChangeToIndexClosure?
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>){
        
        self.init(frame: CGRect.zero, sectionsTitles: sectiontitles, sectionForImages: nil, sectionSelectImages: nil)
        
        self.type = .text
        self.sectionsTitles = sectiontitles

    }


    public convenience init(sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage> ) {
        
        assert((sectionImages.count == selectImages.count) ? true : false, "sectiontitles not equal to the selectImages！")
        
         self.init(frame: CGRect.zero, sectionsTitles: nil, sectionForImages: sectionImages, sectionSelectImages: selectImages)
        self.type = .image
        self.sectionImages = sectionImages
        self.sectionSelectImages = selectImages
 
    }
    
    
    public convenience init(sectionsTitles sectiontitles:Array<String>,sectionForImages sectionImages:Array<UIImage>,sectionSelectImages selectImages:Array<UIImage>) {
      
        assert((sectiontitles.count == sectionImages.count && sectiontitles.count == selectImages.count) ? true : false, "sectiontitles not equal to the selectImages！")
        
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
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    open override var frame: CGRect{
        didSet{
            self.updateSegmentsRects()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateSegmentsRects()
        
    }
    
    
    

    func initialize(){
      self.addSubview(scrollView)

     self.isOpaque = false

     self.contentMode = .redraw
    }
    
    func sectionCount() ->Int{
    
        if self.type == .text {
            return self.sectionsTitles.count
        }else{
            return self.sectionImages.count
        }
    }
    
    // MARK: updateSegmentsRects
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
    
    // MARK:totalSegmentedControlWidth
    func totalSegmentedControlWidth() -> CGFloat {
        
        if self.segmentWidthStyle == .dynamic {
           return self.segmentWidthsArray.reduce(0) {$0 + $1}
        }else{
            return CGFloat(self.sectionsTitles.count) * self.segmentWidth;
        }

    }
    
    

    
    // MARK: draw
    override open func draw(_ rect: CGRect) {

        self.selectionIndicatorStripLayer.backgroundColor = self.selectionIndicatorColor.cgColor
        self.selectionIndicatorArrowLayer.backgroundColor = self.selectionIndicatorColor.cgColor
        self.selectionIndicatorBoxLayer.backgroundColor = self.selectionIndicatorBoxColor.cgColor

        self.backgroundColorSegment?.setFill()
        UIRectFill(self.bounds)
        

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


        self.configAttachmentView()
    }
    
    
    // MARK: loadSegmentedControltypeTextImage
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
                        stringWidth = self.segmentWidthsArray[currentIndex]
                    }else{
                        imageOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - imageWidth) * 0.5
                        textOffsetX = offsetX + (self.segmentWidthsArray[currentIndex] - stringWidth) * 0.5
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
    
    
    
    
    // MARK: loadSegmentedControltypeImage
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

            if self.verticalDividerEnabled == true && index > 0{
                let verticalDividerLayer = CALayer.init()
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.cgColor
                verticalDividerLayer.frame = rectDiv
                self.scrollView.layer.addSublayer(verticalDividerLayer)
            }
            
            self.addBackgroundAndBorderLayerWithRect(rect: resultRect)
            
        }

    }
    
    
    
    
    
    
    // MARK: loadSegmentedControlTypeText
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

            let selectionStyleNotBox = self.selectionStyle != .selectionStyleBox ? true : false
            
            
            let notBoxValue = CGFloat(selectionStyleNotBox.hashValue)
            let locationUpValue = CGFloat(locationUp.hashValue)
            
            let y = (self.frame.size.height - notBoxValue * self.selectionIndicatorHeight) * 0.5 - stringHeight * 0.5 + locationUpValue * self.selectionIndicatorHeight
            
          
            var rectReslut:CGRect = CGRect.zero
            if segmentWidthStyle == .fixed {
                let x = self.segmentWidth * CGFloat(i) + (self.segmentWidth - stringWidth) * 0.5
    
                rectReslut = CGRect.init(x: x, y: y, width: stringWidth, height: stringHeight)
                rectDiv = CGRect.init(x:  self.segmentWidth * CGFloat(i) - self.verticalDividerWidth * 0.5, y: y, width: self.verticalDividerWidth, height: stringHeight)
                fullRect = CGRect.init(x: self.segmentWidth * CGFloat(i), y: 0, width: self.segmentWidth, height: rect.height)
            }else{

                var offset:CGFloat = 0
                for (j,width) in self.segmentWidthsArray.enumerated() {
                    if i == j {break}
                     offset += width
                }
                if self.segmentWidthsArray.count > 0{
                    let stringWidth = self.segmentWidthsArray[i]
                    
                    rectReslut = CGRect.init(x: offset, y: y, width: stringWidth, height: stringHeight)

                    rectDiv = CGRect.init(x:  offset - self.verticalDividerWidth * 0.5, y: y, width: self.verticalDividerWidth, height: stringHeight)
                    fullRect = CGRect.init(x: offset, y: 0, width: stringWidth, height: rect.height)
                }
                
                
            }
            
            
            rectReslut = CGRect.init(x: CGFloat(roundf(Float(rectReslut.origin.x))), y: CGFloat(roundf(Float(rectReslut.origin.y))), width: CGFloat(roundf(Float(rectReslut.size.width))), height: CGFloat(roundf(Float(rectReslut.size.height))))
            
            rectDiv = CGRect.init(x: CGFloat(roundf(Float(rectDiv.origin.x))), y: CGFloat(roundf(Float(rectDiv.origin.y))), width: CGFloat(roundf(Float(rectDiv.size.width))), height: CGFloat(roundf(Float(rectDiv.size.height))))
            
    
            fullRect = CGRect.init(x: CGFloat(roundf(Float(fullRect.origin.x))), y: CGFloat(roundf(Float(fullRect.origin.y))), width: CGFloat(roundf(Float(fullRect.size.width))), height: CGFloat(roundf(Float(fullRect.size.height))))
     
            let titleLayer = CATextLayer.init()
            titleLayer.string = self.textLayerAttributedStringForIndex(index: i);
            titleLayer.frame = rectReslut
            titleLayer.contentsScale = UIScreen.main.scale
            titleLayer.alignmentMode = kCAAlignmentCenter
            self.scrollView.layer.addSublayer(titleLayer)

            if self.verticalDividerEnabled == true && i > 0{
                let verticalDividerLayer = CALayer.init()
                verticalDividerLayer.backgroundColor = self.verticalDividerColor.cgColor
                verticalDividerLayer.frame = rectDiv
                self.scrollView.layer.addSublayer(verticalDividerLayer)
            }
            
            self.addBackgroundAndBorderLayerWithRect(rect: fullRect)
            
        }

    }

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

    func resultingTitleTextAttributes() -> [NSAttributedStringKey:Any] {
        
        var defaultDicts:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)]
        if let normalAttributes = self.normalTitleTextAttributes {
           defaultDicts = defaultDicts.merging(normalAttributes) { (_,new) in new}
        }
          return defaultDicts
    }

    func resultingSelectedTitleTextAttributes() -> [NSAttributedStringKey:Any] {
        var selectDicts:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.init(red: 247/255.0, green: 116/255.0, blue: 116/255.0, alpha: 1)]

        if let selectedAttributes = self.selectedTitleTextAttributes {
            
           selectDicts = selectDicts.merging(selectedAttributes) { (_, new) in new}
        }
        return selectDicts
    }

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

    /// MARK:addBackgroundAndBorderLayerWithRect
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
    
    
    // MARK:frameForSelectionIndicator
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
  
    
    func setArrowFrame(){
        self.selectionIndicatorArrowLayer.frame = self.frameForSelectionIndicator()
        let arrowLayer = CAShapeLayer()

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
    

   public func setSelectedSegmentIndex(index:Int){
        self.setSelectedSegmentIndex(index: index, animation: false, notify: false)
    }
    
   public func setSelectedSegmentIndex(index:Int,animation:Bool){
        self.setSelectedSegmentIndex(index: index, animation: animation, notify: false)
    }
    
   public func setSelectedSegmentIndex(index:Int,animation:Bool,notify:Bool){
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
                
                self.selectionIndicatorStripLayer.actions = nil
                self.selectionIndicatorArrowLayer.actions = nil
                self.selectionIndicatorBoxLayer.actions = nil
                
                
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.4)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear))
                self.selectionIndicatorStripLayer.frame = self.frameForSelectionIndicator()
                self.setArrowFrame()
                selectionIndicatorBoxLayer.frame = self.frameForFillerSelectionIndicator()
                CATransaction.commit()
   
            }else{

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
