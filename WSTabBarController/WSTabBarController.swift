//
//  WSTabbarViewController.swift
//  aimeilive
//
//  Created by chisj on 16/4/27.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

public class WSTabBarController: UITabBarController {
    let wsTabbar = WSTabBar()
    
    public init(publishButtonConfig config:(UIButton ->Void)?, publishButtonClick: (UIButton ->Void)?, publishButtonIndex: Int = -1) {
        super.init(nibName: nil, bundle: nil)
        wsTabbar.set(publishButtonConfig: config, publishButtonClick: publishButtonClick, publishButtonIndex: publishButtonIndex)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(wsTabbar, forKey: "tabBar")
    }
    
}
