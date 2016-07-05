//
//  ViewController.swift
//  PopMenu
//
//  Created by changqi on 7/5/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BlurViewProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1:UIButton = UIButton(frame: CGRectMake(375 * 0.5 - 60, 80, 120, 50));
        button1.backgroundColor = UIColor.blueColor();
        button1.setTitle("上升式弹出", forState: .Normal);
        button1.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        
        let button2:UIButton = UIButton(frame: CGRectMake(375 * 0.5 - 60, 180, 120, 50))
        button2.backgroundColor = UIColor.blueColor();
        button2.setTitle("发散式弹出", forState: .Normal);
        button2.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        
        self.view.addSubview(button1);
        self.view .addSubview(button2);
        
        button1.addTarget(self, action: #selector(self.buttonClicked1), forControlEvents: .TouchUpInside);
        button2.addTarget(self, action: #selector(self.buttonClicked2), forControlEvents: .TouchUpInside);
    }

    func buttonClicked1(){
        let itemArray:Array<MenuItem> = [MenuItem(title: "项目", iconName: "pop_Project", position: 0),
                                         MenuItem(title: "任务", iconName: "pop_Task", position: 1),
                                         MenuItem(title: "状态", iconName: "pop_Tweet", position: 2),
                                         MenuItem(title: "好友", iconName: "pop_User", position: 3),
                                         MenuItem(title: "私信", iconName: "pop_Message", position: 4),
                                         MenuItem(title: "验证", iconName: "pop_2FA", position: 5),
                                         ];
        
        let popMenu:PopMenu = PopMenu(frame: self.view.bounds, item: itemArray);
        popMenu.type = .Rise;
        
        popMenu.itemClicked = { tag in
            print("the \(tag)'s item was clicked.");
        }
        
        popMenu.showMenuAtView(self.view);
    }
    
    func buttonClicked2(){
        let itemArray:Array<MenuItem> = [MenuItem(title: "项目", iconName: "pop_Project", position: 0),
                                         MenuItem(title: "任务", iconName: "pop_Task", position: 1),
                                         MenuItem(title: "状态", iconName: "pop_Tweet", position: 2),
                                         MenuItem(title: "好友", iconName: "pop_User", position: 3),
                                         MenuItem(title: "私信", iconName: "pop_Message", position: 4),
                                         MenuItem(title: "验证", iconName: "pop_2FA", position: 5),
        ];
        
        let popMenu:PopMenu = PopMenu(frame: self.view.bounds, item: itemArray);
        popMenu.type = .Diffuse;
        
        popMenu.itemClicked = { tag in
            print("the \(tag)'s item was clicked.");
        }
        
        popMenu.showMenuAtView(self.view);
    }
    
}

