//
//  PopMenu.swift
//  PopMenu
//
//  Created by changqi on 7/5/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation
import UIKit

let MenuItemHeight:Float = 110
let MenuItemVertivalPadding:Float = 10
let MenuItemHorizontalMargin:Float = 10
let MenuItemAnimationTime:Float = 0.1
let MenuItemAnimationInterval:Float = (MenuItemAnimationTime / 5)

let MenuItemBaseTag = 100

typealias Int2Void = (Int)->Void;

class PopMenu: UIView, BlurViewProtocol{
    enum PopMenuAnimationType {
        case Rise;
        case Diffuse;
    }
    
    var type:PopMenuAnimationType = .Rise;
    
    var items:Array = [MenuItem]();
    
    var perRowItemCount:Int = 3;
    
    var isShowed:Bool = false;
    
    var startPoint:CGPoint!;
    var endPoint:CGPoint!;
    
    var itemClicked:Int2Void?;
    
    lazy var blurView:BlurView = {
        let blur = BlurView(frame: self.bounds);
        blur.hasTapGustureEnable = true;
        blur.showDuration = 0.3;
        blur.dismissDuration = 0.3;
        blur.delegate = self;
        return blur;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
     convenience init(frame:CGRect, item:Array<MenuItem>){
        self.init(frame: frame);
        self.items = item;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMenuAtView(containerView:UIView){
        self.startPoint = CGPoint(x: 0, y: self.bounds.size.height);
        self.endPoint = self.startPoint;
        
        if(self.isShowed){
            return;
        }
        
        self.clipsToBounds = true;
        containerView.addSubview(self);
        
        self.blurView.showBlurViewAtView(self);
    }
    
    func dismissMenu(){
        self.hideItems();
    }
    
    func willShowBlurView() {
        self.isShowed = true;
        
        self.showItems();
    }
    
    func willDismissBlurView() {
        self.dismissMenu();
    }
    
    func didDismissBlurView() {
        self.isShowed = false;
        self.removeFromSuperview();
    }
    
    func showItems(){
        let itemWidth:Float = (Float(self.bounds.size.width) - (Float(self.perRowItemCount + 1) * MenuItemHorizontalMargin)) / Float(perRowItemCount);
        
        var index = 0;
        for menuItem in self.items {
            if menuItem.position < 0{
                menuItem.position = index;
            }
            
            var menuButton:MenuButton? = self.viewWithTag(MenuItemBaseTag+index) as? MenuButton;
            
            let toRect:CGRect = self.getFrameOfItem(AtIndex: index, itemWidth: itemWidth);
            
            var fromRect = toRect;
            
            switch self.type {
                case .Rise:
                    fromRect.origin.y = self.startPoint.y;
                case .Diffuse:
                    fromRect.origin.x = CGRectGetMidX(self.bounds) - CGFloat(itemWidth/2.0);                    fromRect.origin.y = self.startPoint.y;
            }
            
            if menuButton == nil{
                menuButton = MenuButton(frame: fromRect, menuItem: menuItem);
                menuButton!.tag = MenuItemBaseTag + index;
                
                menuButton?.itemClicked = { [unowned self] tag in
                    self.itemClicked?(tag);
                }
                
                self.addSubview(menuButton!);
                
            }
            else{
                menuButton?.frame = fromRect;
            }
            
            let delaySeconds:Double = Double(Float(index) * MenuItemAnimationInterval);
            self.initAnimation(toRect: toRect, fromRect: fromRect, atView: menuButton!, beginTime: delaySeconds);
            
            index += 1;
        }
    }
    
    func hideItems(){
        for index in 0..<self.items.count{
            let menuButton:MenuButton = (self.viewWithTag(MenuItemBaseTag + index) as? MenuButton)!;
            
            let fromRect:CGRect = menuButton.frame;
            var toRect:CGRect = fromRect;
            
            switch self.type {
            case .Rise:
                toRect.origin.y = self.endPoint.y;
            case .Diffuse:
                toRect.origin.x = CGRectGetMidX(self.bounds) - CGFloat(menuButton.bounds.size.width/2.0);
                toRect.origin.y = self.endPoint.y;
            }
            
            let delayInSeconds:Double = Double(Float(self.items.count - index) * MenuItemAnimationInterval);
            
            self.initAnimation(toRect: toRect, fromRect: fromRect, atView: menuButton, beginTime: delayInSeconds);
        }
    }
    
    func initAnimation(toRect toRect:CGRect, fromRect:CGRect, atView:UIView, beginTime:Double){
        let startFrame:CGRect = CGRect(x: fromRect.origin.x, y: fromRect.origin.y, width: atView.bounds.size.width, height: atView.bounds.size.height);
        atView.frame = startFrame;
        
        UIView.animateWithDuration(0.3, delay: beginTime, options: .CurveEaseInOut, animations: {
            let endFrame:CGRect = CGRect(x: toRect.origin.x, y: toRect.origin.y, width: atView.bounds.size.width, height: atView.bounds.size.height);
            atView.frame = endFrame;
            })
            { (finished) in
            
        };
    }
    
    func getFrameOfItem(AtIndex index:Int, itemWidth:Float) -> CGRect {
        //var perColumItemCount = Int(self.items.count/self.perRowItemCount) + (self.items.count%self.perRowItemCount > 0 ? 1 : 0);
        
        let insetY:Float = Float(UIScreen.mainScreen().bounds.size.height) * 0.1 + 64;
        
        let originX:Float = Float(index % self.perRowItemCount) * (itemWidth + MenuItemHorizontalMargin) + MenuItemHorizontalMargin;
        let originY:Float = Float(index / self.perRowItemCount) * (MenuItemHeight + MenuItemVertivalPadding) + MenuItemVertivalPadding;
        
        let itemFrame:CGRect = CGRect(x: CGFloat(originX), y: CGFloat(insetY + originY), width: CGFloat(itemWidth), height: CGFloat(MenuItemHeight));
        
        return itemFrame;
    }
}



class MenuButton: UIView{
    var iconImageView:UIImageView!;
    var titleLabel:UILabel!;
    var menuItem:MenuItem!;
    
    var itemClicked:Int2Void?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    convenience init(frame: CGRect, menuItem:MenuItem){
        self.init(frame: frame);
        
        self.menuItem = menuItem;
        
        self.initContent();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initContent(){
        let imageSize:CGSize = self.menuItem.iconImage.size;
        
        self.iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height));
        self.iconImageView.userInteractionEnabled = true;
        self.iconImageView.image = self.menuItem.iconImage;
        
        self.iconImageView.center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.iconImageView.bounds));
        self.addSubview(self.iconImageView);
        
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(self.iconImageView.frame), width: CGRectGetWidth(self.bounds), height: 35));
        self.titleLabel.textColor = UIColor.blackColor();
        self.titleLabel.backgroundColor = UIColor.clearColor();
        self.titleLabel.font = UIFont.systemFontOfSize(14);
        self.titleLabel.textAlignment = .Center;
        self.titleLabel.text = self.menuItem.title;
        
        var center:CGPoint = self.titleLabel.center;
        center.x = CGRectGetMidX(self.bounds);
        self.titleLabel.center = center;
        self.addSubview(self.titleLabel);
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.itemClickedMethod));
        self.addGestureRecognizer(gesture);
    }
    
    func itemClickedMethod(){
        self.itemClicked?(self.tag - MenuItemBaseTag);
    }
}