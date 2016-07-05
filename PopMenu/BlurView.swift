//
//  BlurView.swift
//  PopMenu
//
//  Created by changqi on 7/5/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

@objc protocol BlurViewProtocol: class{
    optional func willShowBlurView();
    optional func didShowBlurView();
    optional func willDismissBlurView();
    optional func didDismissBlurView();
}

class BlurView: UIView{
    enum BlurType{
        case BlurTypeTranslucent;
        case BlurTypeTranslucentWhite;
        case BlurTypeTranslucentBlack;
        case BlurTypeWhite
    };
    
    var blurType:BlurType = .BlurTypeTranslucentBlack;
    var showed:Bool = false;
    var showDuration:Float = 0.3;
    var dismissDuration:Float = 0.3;
    
    var guestureEnable:Bool = false;
    
    weak var delegate:BlurViewProtocol?;
    
    var hasTapGustureEnable:Bool{
        set(newValue){
            self.guestureEnable = newValue;
            self.setupTapGesture();
        }
        get{
            return self.guestureEnable;
        }
    }
    
    var backgroundView:UIView{
        get{
            switch self.blurType {
            case .BlurTypeTranslucent:
                return self.blurBackgroundView;
            case .BlurTypeTranslucentWhite:
                return self.blurWhiteBackgroundView;
            case .BlurTypeTranslucentBlack:
                return self.blackTranslucentBackgroundView;
            case .BlurTypeWhite:
                return self.whiteBackgroundView;
            }
        }
    }
    
    lazy var blurBackgroundView:UIToolbar = {
        var temp = UIToolbar(frame:self.bounds);
        temp.barStyle = .Black;
        return temp;
    }();
    
    lazy var blurWhiteBackgroundView:UIToolbar = {
        var toolbar = UIToolbar(frame:self.bounds);
        toolbar.barStyle = .Default;
        return toolbar;
    }();
    
    lazy var blackTranslucentBackgroundView:UIView = {
        var view = UIView(frame:self.bounds);
        view.backgroundColor = UIColor(white: 0.000, alpha: 0.500);
        return view;
    }();
    
    lazy var whiteBackgroundView:UIView = {
        var view = UIView(frame:self.bounds);
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0);
        return view;
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func showBlurViewAtView(currentView: UIView){
        self.showAnimationAtContinerView(currentView);
    }
    
    func dismiss(){
        self.hiddenAnimation();
    }
    
    func showAnimationAtContinerView(containerView:UIView){
        if(self.showed){
            self.dismiss();
            return;
        }
        else{
            self.delegate?.willShowBlurView?();
        }
        
        self.alpha = 0.0;
        containerView.insertSubview(self, atIndex: 0);
        
        UIView.animateWithDuration(Double(self.showDuration), delay: 0, options: .CurveEaseInOut, animations: {
                self.alpha = 1.0;
            })
            { (finished) in
                self.showed = true;
                self.delegate?.didShowBlurView?();
        };
    }
    
    func hiddenAnimation(){
        self.delegate?.willDismissBlurView?();
        
        UIView.animateWithDuration(Double(self.dismissDuration), delay: 0, options: .CurveEaseInOut, animations: { 
                self.alpha = 0.0;
            })
            { (finished) in
                self.showed = false;
                self.delegate?.didDismissBlurView?();
                self.removeFromSuperview();
        };
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if(newSuperview != nil){
            let backgroundView = self.backgroundView;
            backgroundView.userInteractionEnabled = false;
            self.addSubview(backgroundView);
        }
    }
    
    func setupTapGesture(){
        if(self.hasTapGustureEnable){
            let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)));
            self.addGestureRecognizer(tap);
        }
    }
    
    func handleTapGesture(gesture:UIGestureRecognizer){
        self.dismiss();
    }
}
