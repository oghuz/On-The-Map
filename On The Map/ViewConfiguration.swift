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
        
    
}


