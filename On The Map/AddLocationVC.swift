//
//  AddLocationVC.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit
import MapKit

class AddLocationVC: UIViewController {
    
    var mapItems: [MKMapItem] = []
    
    @IBOutlet weak var obJectID: UILabel!
    
    let userDefaults = UserDefaults.standard
    var userProfile = [String: AnyObject]()
    var coordination = CLLocationCoordinate2D()
    
    static let keyForProfileArray = "userProfile"
    static let keyForObjectID = "ObjectID"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapString: UITextField!
    
    @IBOutlet weak var mediaUrl: UITextField!
    
    @IBOutlet weak var showOnMapButton: UIButton!
    
    // show the the search result on map
    @IBAction func showOnMap(_ sender: UIButton) {
        
        view.endEditing(true)
        searchForLocationAndLink()
        
        if showOnMapButton.titleLabel?.text == "Finish"{
            
            if userDefaults.string(forKey: AddLocationVC.keyForObjectID) == nil{
                postALocation(POST: true, UPDATE: false)
            }
                
            else if userDefaults.string(forKey: AddLocationVC.keyForObjectID) != nil{
                postALocation(POST: false, UPDATE: true)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //button config
        ViewConfiguration.SharedInstance.buttonConfig(showOnMapButton, backgroundColor: .yellow, textColor: .black, forState: .normal, title: "Validate !")
        
        mapView.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        userProfile = userDefaults.object(forKey: AddLocationVC.keyForProfileArray) as! [String: AnyObject]
    }
    
    func configureViews(){
        
        //configure textfields
        mapString.delegate = self
        mediaUrl.delegate = self
        mapString.placeholder = "Enter Valid Location !"
        mediaUrl.placeholder = "Enter Valid Link !"
        mapString.becomeFirstResponder()
        
        //navigation button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
    }
    
}

//#MARK: Helper methods
extension AddLocationVC{
    
    //search for a location
    func searchForLocationAndLink(){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = mapString.text
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            //checking the error
            guard let theResponse = response, (error == nil) else{
                Alert.SharedInstance.alert(self,title: "Fail", message: "Invalid Location or Link", cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
                
                return
            }
            
            guard let urlString = self.mediaUrl.text, Alert.SharedInstance.isValidURL(urlString) else{
                uiupdateOnMainQueue {
                    Alert.SharedInstance.alert(self,title: "Fail", message: "Invalid Location or Link", cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
                }
                return
            }
            self.showMapview()
            self.mapItems = theResponse.mapItems
            self.searchResultOnMap()
            self.navigationItem.title = "Valid link and Location"
            self.showOnMapButton.setTitle("Finish", for: .normal)
            self.showOnMapButton.backgroundColor = .green
            
        }
        
    }
    
    //POST student Location
    func postALocation(POST: Bool, UPDATE: Bool){
        // parameters for json body
        let uniqueKey = userProfile["key"] as! String
        let firstName = userProfile["first_name"] as! String
        let lastName = userProfile["last_name"] as! String
        let mapString = self.mapString.text
        let mediaUrl = self.mediaUrl.text
        let latitude = coordination.latitude
        let longitude = coordination.longitude
        
        if POST == true{
            
            OnTheMapNetworking.SharedInstance.postStudentLocation(uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString!, mediaUrl: mediaUrl!, latitude: latitude, longitude: longitude) { (result, error) in
                
                //check for error
                guard (error == nil) else {
                    self.userDefaults.set(false, forKey: "didPostedLocation")
                    print("the error posting student location \(error)")
                    return
                }
                
                guard let resultData = result else{
                    self.userDefaults.set(false, forKey: "didPostedLocation")
                    return
                }
                
                if let objectID = resultData["objectId"]{
                    self.userDefaults.set(objectID, forKey: AddLocationVC.keyForObjectID)
                    self.userDefaults.set(true, forKey: "didPostedLocation")
                    uiupdateOnMainQueue {
                        self.cancel()
                    }
                    
                }
                else{
                    uiupdateOnMainQueue {
                        Alert.SharedInstance.alert(self, title: "Update Fail", message: "Could not Update user location", cancel: "Cancel", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: nil, complitionHandler: nil)
                    }
                    
                }
                
                
            }
        }
        
        if UPDATE == true{
            
            if let objectid = userDefaults.string(forKey: AddLocationVC.keyForObjectID){
                let objectId = objectid
                
                
                OnTheMapNetworking.SharedInstance.updateStudentLocation(objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString!, mediaUrl: mediaUrl!, latitude: latitude, longitude: longitude, complitionHandlerForUpdateLocation: { (result, error) in
                    
                    guard (error == nil) else{
                        self.userDefaults.set(false, forKey: "didUpdateLocation")
                        print("there is an error \(error)")
                        uiupdateOnMainQueue {
                            Alert.SharedInstance.alert(self, title: "Post Fail", message: "Could Not Post user location", cancel: "Cancel", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: nil, complitionHandler: { (UIAlertAction) in return})
                        }

                        return
                    }
                    
                    if let data = result, let lastUpdated = data["updatedAt"]{
                        self.userDefaults.set(lastUpdated, forKey: "updatedAt")
                        
                        uiupdateOnMainQueue {
                            self.cancel()
                        }
                        
                    }
                        
                    else{
                        uiupdateOnMainQueue {
                            Alert.SharedInstance.alert(self, title: "Post Fail", message: "Could Not Post user location", cancel: "Cancel", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: nil, complitionHandler: nil)
                        }
                    }
                    
                })
                
            }
        }
    }
    
    
    //showing up mapview by animation
    func showMapview(){
        uiupdateOnMainQueue {
            UIView.animate(withDuration: 1, animations: {
                self.mapView.alpha = 1.0
            })
        }
    }
    
    //add annotation to mapview
    func searchResultOnMap(){
        
        for item in mapItems{
            
            let placeMark = item.placemark
            let coordinates = placeMark.coordinate
            //class property of coordination
            self.coordination = coordinates
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = placeMark.name
            let span = MKCoordinateSpanMake(0.3, 0.3)
            let region = MKCoordinateRegionMake(coordinates, span)
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    func cancel(){
        dismiss(animated: true, completion: nil)
    }
    
}

//#MARK: UITextfieldDelegate
extension AddLocationVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.returnKeyType == .next){
            mapString.resignFirstResponder()
            mediaUrl.becomeFirstResponder()
        }
        else if (textField.returnKeyType == .search){
            self.view.endEditing(true)
            self.showOnMap(showOnMapButton)
            
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
}
