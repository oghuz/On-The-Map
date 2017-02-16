//
//  AlertViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 2/5/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit

class Alert: NSObject {

    //creating singleton object
    static let SharedInstance: Alert = {
        let instance = Alert()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    //creatng a alertview controller to handle the errors
    func alert(_ viewController: UIViewController, title: String?, message: String ,cancel: String?, ok: String?, alertStyle: UIAlertControllerStyle?, actionStyleOk: UIAlertActionStyle?, actionStyleCancel: UIAlertActionStyle?, needOkAction: Bool? ,complitionHandler: ((UIAlertAction)->Void)?){
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: alertStyle!)
        
        if needOkAction == true{
            let okAction = UIAlertAction(title: ok, style: actionStyleOk!, handler: complitionHandler)
            alertView.addAction(okAction)
        }
        //else{
            
            let cancelAction = UIAlertAction(title: cancel, style: actionStyleCancel!, handler: complitionHandler)
            alertView.addAction(cancelAction)
            //}
        
        viewController.present(alertView, animated: true, completion: nil)
    }
    
    func isValidURL(_ urlString: String?)->Bool{
        
        if let urlString = urlString{
            if let url = URL (string: urlString){
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }


}
