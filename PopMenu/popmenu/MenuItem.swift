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
    var position:NSInteger!;
    
    init(title:String, iconName:String, position:NSInteger) {
        super.init();
        self.title = title;
        self.iconImage = UIImage(named: iconName);
        self.position = position;
    }
}
