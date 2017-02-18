//
//  ViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class LogInVC: UIViewController {
    
    
    let userDefaults = UserDefaults.standard
    let udacitySignupURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoUdacity: UILabel!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func login(_ sender: Any) {
        
        //check network connection
    
        //starting indicator
        activityIndicator(start: true)
        passwordField.resignFirstResponder()
        
        //check if username and password is empty
        if ((emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)!) {
            uiupdateOnMainQueue {
                self.activityIndicator(start: false)
                let error = "Email or Passward Empty !"
                Alert.SharedInstance.alert(self,title: "Log In Fail", message: error, cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
            }
        }
            
        else{
            OnTheMapNetworking.SharedInstance.loginWithCredentials(userName: emailField.text!, passward: passwordField.text!, complitionHandlerForLogin: { (success, key, error) in
                uiupdateOnMainQueue {
                    if success{
                        self.saveProfileToUserDefaults(key)
                        self.activityIndicator(start: false)
                        self.completeLogin()
                    }
                    else{
                        self.activityIndicator(start: false)
                        let error = "Invalid Email or Passward !"
                        Alert.SharedInstance.alert(self,title: "Log In Fail", message: error, cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
                    }
                }
            })
        }
    }
    
    //simply open up the udacity sign up page
    @IBAction func signUp(_ sender: Any) {
        //activityIndicator(start: true)
        if #available(iOS 10.0, *){
            UIApplication.shared.open(udacitySignupURL!, options: [:], completionHandler: nil)
        }
        else{
            UIApplication.shared.openURL(udacitySignupURL!)
        }
    }
    
}

//#MARK: - CLogInVC life cycle methods
extension LogInVC{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //text field config
        emailField.placeholder = "Email"
        emailField.backgroundColor = .cyan
        passwordField.placeholder = "Passward"
        passwordField.backgroundColor = .cyan

        //activity indicator
        activityIndicator(start: false)
        
        // buttons configuration
        
        ViewConfiguration.SharedInstance.buttonConfig(loginButton, backgroundColor: .yellow, textColor: .black, forState: .normal, title: "Login")
        
        ViewConfiguration.SharedInstance.buttonConfig(signUpButton, backgroundColor: .yellow, textColor: .red, forState: .normal, title: "Sign Up")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //udacity logo
        UIView.animate(withDuration: 1.0, animations: {
            self.logoUdacity.alpha = 1.0
            self.logoUdacity.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { (true) in
            UIView.animate(withDuration: 0.7, animations: {
                self.logoUdacity.transform = CGAffineTransform(rotationAngle: 0*CGFloat.pi)
                self.logoUdacity.textColor = .cyan
            })
        }
        
        //activity indicator
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(true)
        activityIndicator(start:false)
    }
    
    
}



//#MARK: - helper methods
extension LogInVC{

    // star and stop activity indicator
    func activityIndicator(start: Bool){
        
        if start{
            self.activityIndicator.alpha = 1.0
            self.activityIndicator.startAnimating()
        }
        if !start{
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    //save user profile with nsuserDefault
    func saveProfileToUserDefaults(_ uniuqKey: String?){
        
        //userDefaults.set(toBeSavedArray, forKey: "userProfile")
        if let key = uniuqKey{
            OnTheMapNetworking.SharedInstance.getStudentProfileInfo(key) { (result, error) in
                
                if error == nil{
                    if let profile = result{
                        return self.userDefaults.set(profile, forKey: "userProfile")
                    }
                        
                    else {
                        print("the is no user profile, error \(error)")
                    }
                }
                else{
                    print("error from get student profile methos \(error)")
                }
            }
        }
        
    }
    
    //segue to tabbar controller upon successful login
    func completeLogin(){
        
        //creating instance of tabbar view controller
        let tabbarVC = storyboard!.instantiateViewController(withIdentifier: "TabbarNavigationController") as! UINavigationController
        
        present(tabbarVC, animated: true, completion: nil)
        
    }
    
}

// dealing with keyboard
extension LogInVC: UITextFieldDelegate{
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.returnKeyType == .next){
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if (textField.returnKeyType == .done){
            view.endEditing(true)
            self.login(loginButton)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dontHaveAccountLabel.alpha = 0.0
        signUpButton.alpha = 0.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !emailField.isFirstResponder && !passwordField.isFirstResponder{
            dontHaveAccountLabel.alpha = 1.0
            signUpButton.alpha = 1.0
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        dontHaveAccountLabel.alpha = 1.0
        signUpButton.alpha = 1.0
        
    }
    
}



