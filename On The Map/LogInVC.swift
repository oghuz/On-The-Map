//
//  ViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit
import Foundation

class LogInVC: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    let udacitySignupURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passward: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoUdacity: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func login(_ sender: Any) {
        
        //starting indicator
        activityIndicator(start: true)
        passward.resignFirstResponder()
        
        //check if username and password is empty
        if ((email.text?.isEmpty)! || (passward.text?.isEmpty)!) {
            uiupdateOnMainQueue {
                self.activityIndicator(start: false)
                let error = "Email or Passward Empty !"
                Alert.SharedInstance.alert(self,title: "Log In Fail", message: error, cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
            }
        }
            
        else{
            OnTheMapNetworking.SharedInstance.loginWithCredentials(email.text!, passward: passward.text!, complitionHandlerForLogin: { (success, key, error) in
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
        email.placeholder = "Email"
        email.backgroundColor = .cyan
        passward.placeholder = "Passward"
        passward.backgroundColor = .cyan
        //activity indicator
        activityIndicator(start: false)
        //views background
        let gradientLayer = ViewConfiguration.SharedInstance.viewBackgroundConfig(self.view.bounds, upperColor: .blue, lowerColoer: .cyan, starPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 0.5))
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
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
        email.delegate = self
        passward.delegate = self
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
            email.resignFirstResponder()
            passward.becomeFirstResponder()
        }
        else if (textField.returnKeyType == .done){
            self.view.endEditing(true)
            self.login(loginButton)
        }
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



