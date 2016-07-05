//
//  MenuItem.swift
//  PopMenu
//
//  Created by changqi on 7/5/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation
import UIKit

class MenuItem: NSObject{
    var title:String!;
    var iconImage:UIImage!;
    var glowColor:UIColor?;
    var position:NSInteger!;
    
    init(title:String, iconName:String, glowColor:UIColor, position:NSInteger) {
        self.title = title;
        self.iconImage = UIImage(named: iconName);
        self.glowColor = glowColor;
        self.position = position;
    }
    
    init(title:String, iconName:String, position:NSInteger) {
        self.title = title;
        self.iconImage = UIImage(named: iconName);
        self.position = position;
        
        self.glowColor = nil;
    }
}
