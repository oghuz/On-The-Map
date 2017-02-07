//
//  ViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
    
    
    let udacitySignupURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passward: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func login(_ sender: Any) {
        
    }
    
    //simply open up the udacity sign up page
    @IBAction func signUp(_ sender: Any) {
        if #available(iOS 10.0, *){
            UIApplication.shared.open(udacitySignupURL!, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.openURL(udacitySignupURL!)
        }
    }
    
    
}

