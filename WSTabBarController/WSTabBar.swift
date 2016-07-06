//
//  WSTabbar.swift
//  aimeilive
//
//  Created by chisj on 16/4/27.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

class WSTabBarButton: UIButton {}

class WSTabBar: UITabBar {
    private let defaultPublishHeight : CGFloat = 56
    private let btnPublish = WSTabBarButton(type:.Custom)
    
    private var publishButtonIndex : Int?
    private var publishButtonConfig : (WSTabBarButton ->Void)?
    private var publishButtonClick : (UIButton ->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        btnPublish.backgroundColor = UIColor.clearColor()
        btnPublish.addTarget(self, action: #selector(WSTabBar.publishClick(_:)), forControlEvents: .TouchUpInside)
        addSubview(btnPublish)
        
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(publishButtonConfig config:(UIButton ->Void)?, publishButtonClick: (UIButton ->Void)?, publishButtonIndex: Int) {
        self.publishButtonIndex = publishButtonIndex
        self.publishButtonConfig = config
        self.publishButtonClick = publishButtonClick
        setNeedsLayout()
    }
    
    func publishClick(sender : WSTabBarButton) {
        if let click = publishButtonClick {
            click(sender)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let originBarNumber = items?.count else { return }
        if originBarNumber == 0 {
            return
        }
        let barWidth = frame.size.width
        let barHeight = frame.size.height
        var publishButtonWidth : CGFloat
        var publishButtonHeight : CGFloat
        if let block = publishButtonConfig {
            block(btnPublish)
            publishButtonWidth = btnPublish.frame.size.width
            publishButtonHeight = btnPublish.frame.size.height
        } else {
            //default config
            publishButtonWidth = barWidth / CGFloat(originBarNumber + 1)
            publishButtonHeight = defaultPublishHeight
            btnPublish.backgroundColor = UIColor.redColor()
            btnPublish.setTitle("+", forState: .Normal)
        }
        
        btnPublish.center = CGPointMake(barWidth / 2.0, publishButtonHeight >= barHeight ? barHeight - (publishButtonHeight / 2.0) : barHeight / 2.0)
        let buttonWidth : CGFloat = (barWidth - publishButtonWidth) / CGFloat(originBarNumber)
        
        var publishIndex = 0
        if let customIndex = publishButtonIndex {
            //invalid index
            if customIndex > originBarNumber || customIndex < 0 {
                publishIndex = originBarNumber / 2 == 0 ? 1 : originBarNumber / 2
            } else {
                publishIndex = customIndex
            }
        } else {
            publishIndex = originBarNumber / 2 == 0 ? 1 : originBarNumber / 2
        }
        var index = 0
        subviews.forEach { button in
            if String(button.dynamicType) == "UITabBarButton" {
                button.frame = CGRectMake(index >= publishIndex ? buttonWidth * CGFloat(index) +  publishButtonWidth : buttonWidth * CGFloat(index), button.frame.origin.y, buttonWidth, button.frame.size.height)
                index = index + 1
            }
            if String(button.dynamicType) == "WSTabBarButton" {
                button.frame = CGRectMake(buttonWidth * CGFloat(publishIndex), button.frame.origin.y, publishButtonWidth, publishButtonHeight)
            }
        }
        bringSubviewToFront(btnPublish)
    }
}
