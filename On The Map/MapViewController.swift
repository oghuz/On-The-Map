//
//  MapViewController.swift
//  On The Map
//
//  Created by osmanjan omar on 1/19/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    var userProfile = [String: AnyObject]()
    static let keyForProfileArray = "userProfile"
    
    let userdeFaults = UserDefaults.standard
    
    var annotations = [MKPointAnnotation]()
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        callGetStudentLocation()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userprofile = (userdeFaults.object(forKey: AddLocationVC.keyForProfileArray) as? [String: AnyObject]){            
            userProfile = userprofile
        }
        
        mapView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logout))
        
        let rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation)),
                                   UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(callGetStudentLocation))]
        
        parent?.navigationItem.rightBarButtonItems = rightBarButtonItems
        
    }
    
    func callGetStudentLocation() {
        
        activityIndicator.startAnimating()
        
        view.alpha = 0.7
        
        OnTheMapNetworking.SharedInstance.getStudentsLocations { (studentInformation, error) in
            if let information = studentInformation{
                
                studentInfoArray.sharedInstance.studentInfo = information
                uiupdateOnMainQueue {
                    self.activityIndicator.stopAnimating()
                    self.showPinOnMap(studentInfoArray.sharedInstance.studentInfo)
                }
            }
            else{
                uiupdateOnMainQueue {
                    self.activityIndicator.stopAnimating()
                    Alert.SharedInstance.alert(self,title: "DownLoad Fail", message: "No Data Downloaded !", cancel: "Dismiss", ok: nil, alertStyle: .alert, actionStyleOk: nil, actionStyleCancel: .cancel, needOkAction: false, complitionHandler: nil)
                }
                
                print("\(error)")
            }
        }
    
    }
}


//#MARK: helper methods

extension MapViewController{
    
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showPinOnMap(_ studentInfo: [StudentLocation]){
        //remove old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        for dataItem in studentInfo{
            
            if let latitude = dataItem.latitude, let longitude = dataItem.longitude, let firsName = dataItem.firstName, let lastName = dataItem.lastName, let mediaLink = dataItem.mediaURL{
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = firsName + " " + lastName
                annotation.subtitle = mediaLink
                annotations.append(annotation)
            }
            
        }
        mapView.addAnnotations(annotations)
    }
    
}


//#MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        //activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
        view.alpha = 1.0
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            
            if let urlString = view.annotation?.subtitle{
                
                if Alert.SharedInstance.isValidURL(urlString){
                    if let url = URL(string: urlString!){
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
        if control == view.leftCalloutAccessoryView{
            
            if let item = view.annotation?.coordinate{
                let placeMark = MKPlacemark(coordinate: item, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placeMark)
                if let name = view.annotation?.title{
                    mapItem.name = name
                }
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options)
                
            }
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseID = "PinID"
        var mapPin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if mapPin == nil{
            mapPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            mapPin?.animatesDrop = true
            mapPin?.pinTintColor = .red
            mapPin?.canShowCallout = true
            let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            rightButton.setImage(UIImage(named:"open"), for: .normal)
            
            let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            leftButton.setImage(UIImage(named:"bus"), for: .normal)
            mapPin?.leftCalloutAccessoryView = leftButton
            mapPin?.rightCalloutAccessoryView = rightButton
            
        }
        else{
            mapPin?.annotation = annotation
        }
        return mapPin
    }
    
    
}








