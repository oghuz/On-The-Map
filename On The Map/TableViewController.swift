//
//  TableViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // reference of student location
    var studentInfo = [StudentLocation]()
    let activityIndicator = UIActivityIndicatorView()
    
    var userProfile = [String: AnyObject]()
    let userdeFaults = UserDefaults.standard
    static let keyForProfileArray = "userProfile"
    
    
    //#MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        
        OnTheMapNetworking.SharedInstance.getStudentsLocations { (studentInformation, error) in
            if let information = studentInformation{
                self.studentInfo = information
                uiupdateOnMainQueue {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0.0
                }
            }
            else{
                print("\(error)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userprofile = (userdeFaults.object(forKey: AddLocationVC.keyForProfileArray) as? [String: AnyObject]){            
            userProfile = userprofile
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.alpha = 1.0
        activityIndicator.center = view.center
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .black
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logout))
        
        let rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation)),
                                   UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(viewWillAppear(_:)))]
        
        parent?.navigationItem.rightBarButtonItems = rightBarButtonItems
        
    }
    
}


//#MARK: hepler methods
extension TableViewController{
    
    
    func addLocation(){
        
        if userdeFaults.value(forKey: "ObjectID") != nil{
            let firstName = userProfile["first_name"] as! String
            let lastName = userProfile["last_name"] as! String
            
            uiupdateOnMainQueue {
                Alert.SharedInstance.alert(self, title: nil, message: "User \(firstName) \(lastName) Has Already Posted a Student Location. Would You Like to Overwrite The Location ?", cancel: "Cancel", ok: "Overwrite", alertStyle: .alert, actionStyleOk: .default, actionStyleCancel: .cancel, needOkAction: true, complitionHandler: { (UIAlertAction) in
                    if UIAlertAction.title == "Overwrite"{
                        self.gotoAddLocation()
                    }
                    
                })
            }
            
        }
            
        else if userdeFaults.value(forKey: "ObjectID") == nil {
            gotoAddLocation()
        }
        
    }
    
    func gotoAddLocation(){
        let AddLocationNavigation = storyboard?.instantiateViewController(withIdentifier: "AddLocationNavigation") as! UINavigationController
        present(AddLocationNavigation, animated: true, completion: nil)
    }
    
    
    func logout(){
        
        OnTheMapNetworking.SharedInstance.logoutMethod { (success, error) in
            if success == true{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("\(error)")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
}


//#MARK: UITableView delegate and data sourse
extension TableViewController{
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentInfo.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        let information = studentInfo[indexPath.row]
        
        if let firsName = information.firstName, let lastName = information.lastName, let mediaLink = information.mediaURL{
            cell.textLabel?.text = firsName + " " + lastName
            cell.detailTextLabel?.text = mediaLink
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let urlString = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text{
            
            if Alert.SharedInstance.isValidURL(urlString){
                if let url = URL(string: urlString){
                    if #available(iOS 10.0, *){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else{
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            else{
                uiupdateOnMainQueue {
                    Alert.SharedInstance.alert(self,title: "Fail", message: "Invalid Link", cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
                    
                }
            }
        }
        
    }
    
}
