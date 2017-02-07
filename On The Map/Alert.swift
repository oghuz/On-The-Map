//
//  AlertViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 2/5/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit

class Alert: UIViewController {
    
    //creating a singleton
    static let SharedInstance: Alert = {
        let instance = Alert()
        return instance
    }()

    //creatng a alertview controller to handle the errors
    func alert(_ title: String, message: String ,cancel: String?, ok: String, alertStyle: UIAlertControllerStyle?, actionStyle: UIAlertActionStyle?, complitionHandler: ((UIAlertAction)->Void)?){
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: complitionHandler)
        let okAction = UIAlertAction(title: ok, style: .default, handler: complitionHandler)
        
        alertView.addAction(cancelAction)
        alertView.addAction(okAction)
        
        self.present(alertView, animated: true)
        
    }

}
