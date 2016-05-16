//
//  BTConfiguration.swift
//  BTNavigationDropdownMenu
//
//  Created by Pham Ba Tho on 6/30/15.
//  Copyright (c) 2015 PHAM BA THO. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit


// MARK: BTNavigationDropdownMenu
public class BTNavigationDropdownMenu: UIView {
    
    // The color of menu title. Default is darkGrayColor()
    public var menuTitleColor: UIColor! {
        get {
            return self.configuration.menuTitleColor
        }
        set(value) {
            self.configuration.menuTitleColor = value
        }
    }
    public var backgroundView: UIView! {
        get {
            return self.configuration.backgroundView
        }
        set(value) {
            self.configuration.backgroundView = value
        }
    }
    
    // The height of the cell. Default is 50
    public var cellHeight: CGFloat! {
        get {
            return self.configuration.cellHeight
        }
        set(value) {
            self.configuration.cellHeight = value
        }
    }
    
    // The color of the cell background. Default is whiteColor()
    public var cellBackgroundColor: UIColor! {
        get {
            return self.configuration.cellBackgroundColor
        }
        set(color) {
            self.configuration.cellBackgroundColor = color
        }
    }
    
    public var cellSeparatorColor: UIColor! {
        get {
            return self.configuration.cellSeparatorColor
        }
        set(value) {
            self.configuration.cellSeparatorColor = value
        }
    }
    
    // The color of the text inside cell. Default is darkGrayColor()
    public var cellTextLabelColor: UIColor! {
        get {
            return self.configuration.cellTextLabelColor
        }
        set(value) {
            self.configuration.cellTextLabelColor = value
        }
    }
    
    // The font of the text inside cell. Default is HelveticaNeue-Bold, size 19
    public var cellTextLabelFont: UIFont! {
        get {
            return self.configuration.cellTextLabelFont
        }
        set(value) {
            self.configuration.cellTextLabelFont = value
            self.menuTitle.font = self.configuration.cellTextLabelFont
        }
    }
    
    // The alignment of the text inside cell. Default is .Left
    public var cellTextLabelAlignment: NSTextAlignment! {
        get {
            return self.configuration.cellTextLabelAlignment
        }
        set(value) {
            self.configuration.cellTextLabelAlignment = value
        }
    }
    
    // The color of the cell when the cell is selected. Default is lightGrayColor()
    public var cellSelectionColor: UIColor! {
        get {
            return self.configuration.cellSelectionColor
        }
        set(value) {
            self.configuration.cellSelectionColor = value
        }
    }
    
    // The checkmark icon of the cell
    public var checkMarkImage: UIImage! {
        get {
            return self.configuration.checkMarkImage
        }
        set(value) {
            self.configuration.checkMarkImage = value
        }
    }
    
    // The animation duration of showing/hiding menu. Default is 0.3
    public var animationDuration: NSTimeInterval! {
        get {
            return self.configuration.animationDuration
        }
        set(value) {
            self.configuration.animationDuration = value
        }
    }

    // The arrow next to navigation title
    public var arrowImage: UIImage! {
        get {
            return self.configuration.arrowImage
        }
        set(value) {
            self.configuration.arrowImage = value
            self.menuArrow.image = self.configuration.arrowImage
        }
    }
    
    // The padding between navigation title and arrow
    public var arrowPadding: CGFloat! {
        get {
            return self.configuration.arrowPadding
        }
        set(value) {
            self.configuration.arrowPadding = value
        }
    }
    
    // The color of the mask layer. Default is blackColor()
    public var maskBackgroundColor: UIColor! {
        get {
            return self.configuration.maskBackgroundColor
        }
        set(value) {
            self.configuration.maskBackgroundColor = value
        }
    }
    
    // The opacity of the mask layer. Default is 0.3
    public var maskBackgroundOpacity: CGFloat! {
        get {
            return self.configuration.maskBackgroundOpacity
        }
        set(value) {
            self.configuration.maskBackgroundOpacity = value
        }
    }
    
    public var didSelectItemAtIndexHandler: ((indexPath: Int) -> ())?
    public var isShown: Bool!

    private var navigationController: UINavigationController?
    private var configuration = BTConfiguration()
    private var topSeparator: UIView!
    private var menuButton: UIButton!
    private var menuTitle: UILabel!
    private var menuArrow: UIImageView!
    private var tableView: BTTableView!
    private var items: [AnyObject]!
    private var menuWrapper: UIView!
    private var tapView: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, deprecated, message="Use init(navigationController:title:items:) instead", renamed="BTNavigationDropdownMenu(navigationController: UINavigationController?, title: String, items: [AnyObject])")
    public convenience init(title: String, items: [AnyObject]) {
        self.init(navigationController: nil, title: title, items: items)
    }
    
    public init(navigationController: UINavigationController?, title: String, items: [AnyObject]) {
        
        // Navigation controller
        if let navigationController = navigationController {
            self.navigationController = navigationController
        } else {
            self.navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController?.topMostViewController?.navigationController
        }
        
        // Get titleSize
        let titleSize = (title as NSString).sizeWithAttributes([NSFontAttributeName:self.configuration.cellTextLabelFont])
        
        // Set frame
        let frame = CGRectMake(0, 0, titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage.size.width)*2, self.navigationController!.navigationBar.frame.height)
        
        super.init(frame:frame)
        
        self.navigationController?.view.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        
        self.isShown = false
        self.items = items
        
        // Init properties
        self.setupDefaultConfiguration()

        // Init button as navigation title
        self.menuButton = UIButton(frame: frame)
        self.menuButton.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.menuButton)
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle.text = title
        self.menuTitle.textColor = self.menuTitleColor
        self.menuTitle.font = self.configuration.cellTextLabelFont
        self.menuTitle.textAlignment = self.configuration.cellTextLabelAlignment
        self.menuButton.addSubview(self.menuTitle)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage)
        self.menuButton.addSubview(self.menuArrow)
        
        let window = UIApplication.sharedApplication().keyWindow!
        let menuWrapperBounds = window.bounds
        
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRectMake(menuWrapperBounds.origin.x, 0, menuWrapperBounds.width, menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init background view (under table view)

        self.tapView = UIView(frame: menuWrapperBounds)
        self.tapView.backgroundColor = self.configuration.maskBackgroundColor
        self.tapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: "hideMenu");
        self.tapView.addGestureRecognizer(backgroundTapRecognizer)
        if self.backgroundView != nil {
           
            self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
             self.tableView.backgroundView = self.backgroundView
        }
       
        
        // Init table view
        self.tableView = BTTableView(frame: CGRectMake(menuWrapperBounds.origin.x, menuWrapperBounds.origin.y + 0.5, menuWrapperBounds.width, menuWrapperBounds.height + 300), items: items, configuration: self.configuration)
        
        self.tableView.selectRowAtIndexPathHandler = { (indexPath: Int) -> () in
            self.didSelectItemAtIndexHandler!(indexPath: indexPath)
            self.setMenuTitle("\(items[indexPath])")
            self.hideMenu()
            self.layoutSubviews()
        }
        
        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.tapView)
        self.menuWrapper.addSubview(self.tableView)
        
        // Add Line on top
        self.topSeparator = UIView(frame: CGRectMake(0, 0, menuWrapperBounds.size.width, 0.5))
        self.topSeparator.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.menuWrapper.addSubview(self.topSeparator)
        
        // Add Menu View to container view
        window.addSubview(self.menuWrapper)
        
        // By default, hide menu view
        self.menuWrapper.hidden = true
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            // Set up DropdownMenu
            self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
            self.tableView.reloadData()
        }
    }
    
    override public func layoutSubviews() {
        self.menuTitle.sizeToFit()
        self.menuTitle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.menuArrow.sizeToFit()
        self.menuArrow.center = CGPointMake(CGRectGetMaxX(self.menuTitle.frame) + self.configuration.arrowPadding, self.frame.size.height/2)
    }
    
    public func show() {
        if self.isShown == false {
            self.showMenu()
        }
    }
    
    public func hide() {
        if self.isShown == true {
            self.hideMenu()
        }
    }
    
    func setupDefaultConfiguration() {
 
        
        self.menuTitleColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor // Setter
        self.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        self.cellSeparatorColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        self.cellTextLabelColor = self.navigationController?.navigationBar.titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
    }
    
    func showMenu() {
        self.menuWrapper.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
        
        self.isShown = true
        
        // Table view header
        let headerView = UIView(frame: CGRectMake(0, 0, self.frame.width, 300))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView
        
        self.topSeparator.backgroundColor = self.configuration.cellSeparatorColor
        
        // Rotate arrow
        self.rotateArrow()
        
        // Visible menu view
        self.menuWrapper.hidden = false
        
        // Change background alpha
        self.tapView.alpha = 0
        
        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
        
        // Reload data to dismiss highlight color of selected cell
        self.tableView.reloadData()
        
        self.menuWrapper.superview?.bringSubviewToFront(self.menuWrapper)
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-300)
                self.tapView.alpha = self.configuration.maskBackgroundOpacity
            }, completion: nil
        )
    }
    
    func hideMenu() {
        // Rotate arrow
        self.rotateArrow()
        
        self.isShown = false
        
        // Change background alpha
        self.tapView.alpha = self.configuration.maskBackgroundOpacity
        
        UIView.animateWithDuration(
            self.configuration.animationDuration * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.tableView.frame.origin.y = CGFloat(-200)
            }, completion: nil
        )
        
        // Animation
        UIView.animateWithDuration(self.configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
            self.tapView.alpha = 0
            }, completion: { _ in
                self.menuWrapper.hidden = true
        })
    }
    
    func rotateArrow() {
        UIView.animateWithDuration(self.configuration.animationDuration, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = CGAffineTransformRotate(selfie.menuArrow.transform, 180 * CGFloat(M_PI/180))
            }
            })
    }
    
    func setMenuTitle(title: String) {
        self.menuTitle.text = title
    }
    
    func menuButtonTapped(sender: UIButton) {
        self.isShown == true ? hideMenu() : showMenu()
    }
}

// MARK: BTConfiguration
class BTConfiguration {
    var menuTitleColor: UIColor?
    var cellHeight: CGFloat!
    var cellBackgroundColor: UIColor?
    var cellSeparatorColor: UIColor?
    var cellTextLabelColor: UIColor?
    var cellTextLabelFont: UIFont!
    var cellTextLabelAlignment: NSTextAlignment!
    var cellSelectionColor: UIColor?
    var checkMarkImage: UIImage!
    var arrowImage: UIImage!
    var arrowPadding: CGFloat!
    var animationDuration: NSTimeInterval!
    var maskBackgroundColor: UIColor!
    var maskBackgroundOpacity: CGFloat!
    var backgroundView: UIView!
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        // Path for image
        let bundle = NSBundle(forClass: BTConfiguration.self)
        let url = bundle.URLForResource("BTNavigationDropdownMenu", withExtension: "bundle")
        let imageBundle = NSBundle(URL: url!)
        let checkMarkImagePath = imageBundle?.pathForResource("checkmark_icon", ofType: "png")
        let arrowImagePath = imageBundle?.pathForResource("arrow_down_icon", ofType: "png")

        // Default values
        self.menuTitleColor = UIColor.darkGrayColor()
        self.cellHeight = 50
        self.cellBackgroundColor = UIColor.whiteColor()
        self.cellSeparatorColor = UIColor.darkGrayColor()
        self.cellTextLabelColor = UIColor.darkGrayColor()
        self.cellTextLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.cellTextLabelAlignment = NSTextAlignment.Left
        self.cellSelectionColor = UIColor.lightGrayColor()
        self.checkMarkImage = UIImage(contentsOfFile: checkMarkImagePath!)
        self.animationDuration = 0.5
        self.arrowImage = UIImage(contentsOfFile: arrowImagePath!)
        self.arrowPadding = 15
        self.maskBackgroundColor = UIColor.blackColor()
        self.maskBackgroundOpacity = 0.3
    }
}

// MARK: Table View
class BTTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: BTConfiguration!
    var selectRowAtIndexPathHandler: ((indexPath: Int) -> ())?
    
    // Private properties
    private var items: [AnyObject]!
    private var selectedIndexPath: Int!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [AnyObject], configuration: BTConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.items = items
        self.selectedIndexPath = 0
        self.configuration = configuration
        self.backgroundColor = UIColor.clearColor()
        // Setup table view
        self.delegate = self
        self.dataSource = self
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.tableFooterView = UIView(frame: CGRectZero)
        if self.backgroundView != nil {
            self.backgroundView = backgroundView
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, withEvent: event) where hitView.isKindOfClass(BTTableCellContentView.self) {
            return hitView
        }
        return nil;
    }
    
    // Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BTTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row] as? String
        cell.checkmarkIcon.hidden = (indexPath.row == selectedIndexPath) ? false : true

        return cell
    }
    
    // Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath: indexPath.row)
        self.reloadData()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? BTTableViewCell
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? BTTableViewCell
        cell?.checkmarkIcon.hidden = true
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
    }
}

// MARK: Table view cell
class BTTableViewCell: UITableViewCell {
    let checkmarkIconWidth: CGFloat = 50
    let horizontalMargin: CGFloat = 20
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: BTConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: BTConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRectMake(0, 0, (UIApplication.sharedApplication().keyWindow?.frame.width)!, self.configuration.cellHeight)
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        let gradView = GradientView(frame: cellContentFrame)
        gradView.direction = .Horizontal
        gradView.colors = [UIColor(hue: 337/360, saturation: 69/100, brightness: 65/100, alpha: 1.0), UIColor(hue: 11/360, saturation: 73/100, brightness: 83/100, alpha: 1.0)]
    
        self.backgroundView = gradView
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        self.textLabel!.font = self.configuration.cellTextLabelFont
        self.textLabel!.textAlignment = self.configuration.cellTextLabelAlignment
        if self.textLabel!.textAlignment == .Center {
            self.textLabel!.frame = CGRectMake(0, 0, cellContentFrame.width, cellContentFrame.height)
        } else if self.textLabel!.textAlignment == .Left {
            self.textLabel!.frame = CGRectMake(horizontalMargin, 0, cellContentFrame.width, cellContentFrame.height)
        } else {
            self.textLabel!.frame = CGRectMake(-horizontalMargin, 0, cellContentFrame.width, cellContentFrame.height)
        }
        
        // Checkmark icon
        if self.textLabel!.textAlignment == .Center {
            self.checkmarkIcon = UIImageView(frame: CGRectMake(cellContentFrame.width - checkmarkIconWidth, (cellContentFrame.height - 30)/2, 30, 30))
        } else if self.textLabel!.textAlignment == .Left {
            self.checkmarkIcon = UIImageView(frame: CGRectMake(cellContentFrame.width - checkmarkIconWidth, (cellContentFrame.height - 30)/2, 30, 30))
        } else {
            self.checkmarkIcon = UIImageView(frame: CGRectMake(horizontalMargin, (cellContentFrame.height - 30)/2, 30, 30))
        }
        self.checkmarkIcon.hidden = true
        self.checkmarkIcon.image = self.configuration.checkMarkImage
        self.checkmarkIcon.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.checkmarkIcon)
        
        // Separator for cell
        let separator = BTTableCellContentView(frame: cellContentFrame)
        if let cellSeparatorColor = self.configuration.cellSeparatorColor {
            separator.separatorColor = cellSeparatorColor
        }
        self.contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class BTTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor)
        CGContextSetLineWidth(context, 1)
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}

extension UIViewController {
    // Get ViewController in top present level
    var topPresentedViewController: UIViewController? {
        var target: UIViewController? = self
        while (target?.presentedViewController != nil) {
            target = target?.presentedViewController
        }
        return target
    }
    
    // Get top VisibleViewController from ViewController stack in same present level.
    // It should be visibleViewController if self is a UINavigationController instance
    // It should be selectedViewController if self is a UITabBarController instance
    var topVisibleViewController: UIViewController? {
        if let navigation = self as? UINavigationController {
            if let visibleViewController = navigation.visibleViewController {
                return visibleViewController.topVisibleViewController
            }
        }
        if let tab = self as? UITabBarController {
            if let selectedViewController = tab.selectedViewController {
                return selectedViewController.topVisibleViewController
            }
        }
        return self
    }
    
    // Combine both topPresentedViewController and topVisibleViewController methods, to get top visible viewcontroller in top present level
    var topMostViewController: UIViewController? {
        return self.topPresentedViewController?.topVisibleViewController
    }
}

//
//  GradientView.swift
//  Gradient View
//
//  Created by Sam Soffes on 10/27/09.
//  Copyright (c) 2009-2014 Sam Soffes. All rights reserved.
//

import UIKit

/// Simple view for drawing gradients and borders.
@IBDesignable
public class GradientView: UIView {
    
    // MARK: - Types
    
    /// The mode of the gradient.
    public enum Type {
        /// A linear gradient.
        case Linear
        
        /// A radial gradient.
        case Radial
    }
    
    
    /// The direction of the gradient.
    public enum Direction {
        /// The gradient is vertical.
        case Vertical
        
        /// The gradient is horizontal
        case Horizontal
    }
    
    
    // MARK: - Properties
    
    /// An optional array of `UIColor` objects used to draw the gradient. If the value is `nil`, the `backgroundColor`
    /// will be drawn instead of a gradient. The default is `nil`.
    public var colors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// An array of `UIColor` objects used to draw the dimmed gradient. If the value is `nil`, `colors` will be
    /// converted to grayscale. This will use the same `locations` as `colors`. If length of arrays don't match, bad
    /// things will happen. You must make sure the number of dimmed colors equals the number of regular colors.
    ///
    /// The default is `nil`.
    public var dimmedColors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }
    
    /// Automatically dim gradient colors when prompted by the system (i.e. when an alert is shown).
    ///
    /// The default is `true`.
    public var automaticallyDims: Bool = true
    
    /// An optional array of `CGFloat`s defining the location of each gradient stop.
    ///
    /// The gradient stops are specified as values between `0` and `1`. The values must be monotonically increasing. If
    /// `nil`, the stops are spread uniformly across the range.
    ///
    /// Defaults to `nil`.
    public var locations: [CGFloat]? {
        didSet {
            updateGradient()
        }
    }
    
    /// The mode of the gradient. The default is `.Linear`.
    @IBInspectable
    public var mode: Type = .Linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The direction of the gradient. Only valid for the `Mode.Linear` mode. The default is `.Vertical`.
    @IBInspectable
    public var direction: Direction = .Vertical {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 1px borders will be drawn instead of 1pt borders. The default is `true`.
    @IBInspectable
    public var drawsThinBorders: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The top border color. The default is `nil`.
    @IBInspectable
    public var topBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The right border color. The default is `nil`.
    @IBInspectable
    public var rightBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///  The bottom border color. The default is `nil`.
    @IBInspectable
    public var bottomBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The left border color. The default is `nil`.
    @IBInspectable
    public var leftBorderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: - UIView
    
    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let size = bounds.size
        
        // Gradient
        if let gradient = gradient {
            let options: CGGradientDrawingOptions = [.DrawsAfterEndLocation]
            
            if mode == .Linear {
                let startPoint = CGPointZero
                let endPoint = direction == .Vertical ? CGPoint(x: 0, y: size.height) : CGPoint(x: size.width, y: 0)
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options)
            } else {
                let center = CGPoint(x: bounds.midX, y: bounds.midY)
                CGContextDrawRadialGradient(context, gradient, center, 0, center, min(size.width, size.height) / 2, options)
            }
        }
        
        let screen: UIScreen = window?.screen ?? UIScreen.mainScreen()
        let borderWidth: CGFloat = drawsThinBorders ? 1.0 / screen.scale : 1.0
        
        // Top border
        if let color = topBorderColor {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, CGRect(x: 0, y: 0, width: size.width, height: borderWidth))
        }
        
        let sideY: CGFloat = topBorderColor != nil ? borderWidth : 0
        let sideHeight: CGFloat = size.height - sideY - (bottomBorderColor != nil ? borderWidth : 0)
        
        // Right border
        if let color = rightBorderColor {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, CGRect(x: size.width - borderWidth, y: sideY, width: borderWidth, height: sideHeight))
        }
        
        // Bottom border
        if let color = bottomBorderColor {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, CGRect(x: 0, y: size.height - borderWidth, width: size.width, height: borderWidth))
        }
        
        // Left border
        if let color = leftBorderColor {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillRect(context, CGRect(x: 0, y: sideY, width: borderWidth, height: sideHeight))
        }
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        if automaticallyDims {
            updateGradient()
        }
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        contentMode = .Redraw
    }
    
    
    // MARK: - Private
    
    private var gradient: CGGradientRef?
    
    private func updateGradient() {
        gradient = nil
        setNeedsDisplay()
        
        let colors = gradientColors()
        if let colors = colors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorSpaceModel = CGColorSpaceGetModel(colorSpace)
            
            let gradientColors: NSArray = colors.map { (color: UIColor) -> AnyObject! in
                let cgColor = color.CGColor
                let cgColorSpace = CGColorGetColorSpace(cgColor)
                
                // The color's color space is RGB, simply add it.
                if CGColorSpaceGetModel(cgColorSpace).rawValue == colorSpaceModel.rawValue {
                    return cgColor as AnyObject!
                }
                
                // Convert to RGB. There may be a more efficient way to do this.
                var red: CGFloat = 0
                var blue: CGFloat = 0
                var green: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UIColor(red: red, green: green, blue: blue, alpha: alpha).CGColor as AnyObject!
            }
            
            // TODO: This is ugly. Surely there is a way to make this more concise.
            if let locations = locations {
                gradient = CGGradientCreateWithColors(colorSpace, gradientColors, locations)
            } else {
                gradient = CGGradientCreateWithColors(colorSpace, gradientColors, nil)
            }
        }
    }
    
    private func gradientColors() -> [UIColor]? {
        if tintAdjustmentMode == .Dimmed {
            if let dimmedColors = dimmedColors {
                return dimmedColors
            }
            
            if automaticallyDims {
                if let colors = colors {
                    return colors.map {
                        var hue: CGFloat = 0
                        var brightness: CGFloat = 0
                        var alpha: CGFloat = 0
                        
                        $0.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
                        
                        return UIColor(hue: hue, saturation: 0, brightness: brightness, alpha: alpha)
                    }
                }
            }
        }
        
        return colors
    }
}

