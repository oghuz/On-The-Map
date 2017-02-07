//
//  viewControllersConfig.swift
//  On The Map
//
//  Created by osmanjan omar on 2/1/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//
import UIKit

extension LogInVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //views background
        let gradientLayer = ViewConfiguration.SharedInstance.viewBackgroundConfig(self.view.bounds, upperColor: .red, lowerColoer: .yellow, starPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 0.5))
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // buttons configuration
        
        ViewConfiguration.SharedInstance.buttonConfig(loginButton, backgroundColor: .yellow, textColor: .black, forState: .normal, title: "Login")
        
        ViewConfiguration.SharedInstance.buttonConfig(signUpButton, backgroundColor: .yellow, textColor: .red, forState: .normal, title: "Sign Up")
    }
    
}


extension TableViewController{

 

}

