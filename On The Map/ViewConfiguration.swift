//
//  ViewConfiguration.swift
//  On The Map
//
//  Created by osmanjan omar on 2/1/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit

class ViewConfiguration: UIView{
    
    // creating a singleton object
    static let SharedInstance: ViewConfiguration = {
        let instance = ViewConfiguration()
        return instance
    }()
    
    
    //#MARK: -ViewSetup
    override class var layerClass: AnyClass{
        return CAGradientLayer.self
    }
    
    
    //take a view and configure it
    func viewBackgroundConfig(_ frame: CGRect, upperColor: UIColor, lowerColoer: UIColor, starPoint: CGPoint?, endPoint: CGPoint?)->CAGradientLayer {
        //setting up the background colors
        var caDradienLayer: CAGradientLayer{
            return layer as! CAGradientLayer
        }
        caDradienLayer.startPoint = starPoint!
        caDradienLayer.endPoint = endPoint!
        caDradienLayer.frame = frame
        let colors = [upperColor.cgColor, lowerColoer.cgColor]
        caDradienLayer.colors = colors
        
        return caDradienLayer
        
    }
    //configure a button on call
    func buttonConfig(_ button: UIButton, backgroundColor: UIColor?, textColor: UIColor?, forState: UIControlState?, title: String?){
        
        button.clipsToBounds = true
        button.layer.cornerRadius = 4.0
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: forState!)
        button.setTitle(title, for: forState!)
        
    }
    
    //#MARK: - Move up and Move Down screen
    
    
    // subscribing the keyboardWillShowUp method
    
    func subscribeToKeyBoardWillShowNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(theKeyboardWillShowUp), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    // unsubscribe from keyboard show notification
    func unsunscribeFromKeyboardWillShowNotification(){
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    // move up the buttom textfield and pull down the top textfield when keyboard show up
    func theKeyboardWillShowUp(notification:NSNotification, view: UIView){
        
        
        view.frame.origin.y -= 40
        
        
    }
    
    // # MARK: moving down the view when keyborad hide
    
    // subscribe to the UIKeyboardWillHide notification
    
    func subscribeToKeyBoardWillHideNotification(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownTheView), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    //unsubscribe from the notification
    func unsubscribeFromKeyBoardWillHideNotification(){
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // set the y origin to original point
    func moveDownTheView(notification:NSNotification, view: UIView){
        
        
        view.frame.origin.y += 40
        
    }
    

    
    
}


