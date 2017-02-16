//
//  ConvenienceMethods.swift
//  On The Map
//
//  Created by osmanjan omar on 2/7/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation
import UIKit

extension OnTheMapNetworking{
    //#MARK: - Log In With Username And Passward
    func loginWithCredentials(_ userName: String, passward: String, complitionHandlerForLogin :@escaping(_ success: Bool, _ key: String?, _ error: Error?)->Void){
        
        //json body of dictionary contains username and passward
        let jsonCredentials = "{\"\(Constents.Udacity)\":{\"\(Constents.UserName)\":\"\(userName)\", \"\(Constents.Passward)\":\"\(passward)\"}}"
        
        let _ = taskForMutableRequest(nil, requestMethod: "POST", parameters: nil, hostName: Constents.UdacityHostName, pathName: Constents.UdacityAPIPath, jsonBody: jsonCredentials, needParseValues: false, needHeaderValues: true, needOriginalData: true) { (anyObject, rawData, error) in
            
            //when we log in with udacity username and passward, the data has some security characters, parsing it will give error unless we take out the sub data,  so  in here we should skip checking if error is nil,
            
            //checking for error
            guard (error == nil) else{
                complitionHandlerForLogin(false, nil, error)
                return
            }
            
            guard let data = rawData else{
                complitionHandlerForLogin(false, nil, error)
                
                return
            }
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            var result: AnyObject? = nil
            do {
                result = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                complitionHandlerForLogin(false, nil, error)
                return
            }
            
            if let account = result?[Constents.Account] as? [String: AnyObject], let key = account[Constents.Key] as? String ,let registered = account[Constents.DidRegistered] as? Bool, registered == true{
                complitionHandlerForLogin(true, key, nil)
            }
            else{
                complitionHandlerForLogin(false, nil, error)
                
            }
        }
    }
    
    //#MARK: - get udacity student public profile
    func getStudentProfileInfo(_ uniqueKey: String, complitionHandlerForGetProfileInfo: @escaping(_ profileArray: [String: AnyObject]?, _ error: Error?)->Void){
        
        let uniqueKey = uniqueKey
        
        let _ = taskForGETMethod(uniqueKey, nil, hostName: Constents.UdacityHostName, pathName: Constents.UdacityUserAPIPath, needParseValues: false, needHeaderValues: false, needOriginalData: true) { (result, originalData, error) in
            
            //checking for error
            guard (error == nil) else{
                complitionHandlerForGetProfileInfo(nil, error)
                return
            }
            
            guard let Rawdata = originalData else{
                complitionHandlerForGetProfileInfo(nil, error)
                return
            }
            let range = Range(uncheckedBounds: (5, Rawdata.count))
            let newData = Rawdata.subdata(in: range)
            var result: AnyObject? = nil
            do {
                result = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                complitionHandlerForGetProfileInfo(nil, error)
                return
            }
            
            if let user = result?["user"] as? [String: AnyObject], let last_name = user["last_name"] as? String ,let first_name = user["first_name"] as? String, let key = user["key"] as? String{
                
                let profileDictionary = ["first_name": first_name, "last_name": last_name, "key": key]
                
                complitionHandlerForGetProfileInfo(profileDictionary as [String : AnyObject]?, nil)
                print(" ----------getStudentProfileInfo-----------the user info  array \(first_name), \(last_name), \(key)")
            }
            else{
                complitionHandlerForGetProfileInfo(nil, error)
                print(" ---------------------the user info  array \(error)")
            }
            
        }
        
    }
    
    //#MARK: - LogOut And Delete Session
    func logoutMethod(complitionHandlerForLogOut :@escaping(_ success: Bool, _ error: Error?)->Void){
        
        let request = NSMutableURLRequest(url: URLFromComponents(nil, hostName: Constents.UdacityHostName, pathName: Constents.UdacityAPIPath, withPathExtension: nil))
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!{
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie{
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else{
                complitionHandlerForLogOut(false, error)
                print("------error loging out \(error)")
                return
            }
            
            complitionHandlerForLogOut(true, nil)
            
            let range = Range(uncheckedBounds: (lower: 5, upper: data!.count - 5))
            let newData = data?.subdata(in: range)
            print("------log out Data is ********\(newData)")
        }
        
        task.resume()
    }
    
    //#MARK: - Get Students Locations
    func getStudentsLocations(_ complitionHandlerForGetStudentsLocations: @escaping(_ result: [StudentLocation]?, _ error: Error?)->Void){
        
        //calling task for Get method
        
        let _ = taskForGETMethod(nil, nil, hostName: Constents.ParseHostName, pathName: Constents.ParseAPIPath, needParseValues: true, needHeaderValues: false, needOriginalData: false) { (parsedData, originalData, error) in
            
            //cheking the error
            guard (error == nil) else{
                complitionHandlerForGetStudentsLocations(nil, error)
                return
            }
            
            if let results = parsedData?["results"] as? [[String: AnyObject]]{
                let studentInfo = StudentLocation.studentInfoFromDictionary(results)
                complitionHandlerForGetStudentsLocations(studentInfo, nil)
            }
            else{
                complitionHandlerForGetStudentsLocations(nil, error)
            }
        }
        
    }
    
    //#MARK: - POST student location
    func postStudentLocation(_ uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, complitionHandlerForPostLocation: @escaping(_ result: AnyObject?, _ error: Error?)->Void){
        
        let jsonBody = "{\"\(StudentLocationKey.uniqueKey)\": \"\(uniqueKey)\", \"\(StudentLocationKey.firstName)\": \"\(firstName)\", \"\(StudentLocationKey.lastName)\": \"\(lastName)\", \"\(StudentLocationKey.mapString)\": \"\(mapString)\", \"\(StudentLocationKey.mediaURL)\": \"\(mediaUrl)\", \"\(StudentLocationKey.latitude)\": \(latitude), \"\(StudentLocationKey.longitude)\": \(longitude)}"
        
        let _ = taskForMutableRequest(nil, requestMethod: Constents.MethodPOST, parameters: nil, hostName: Constents.ParseHostName, pathName: Constents.ParseAPIPath, jsonBody: jsonBody, needParseValues: true, needHeaderValues: true, needOriginalData: false) { (result, originalData, error) in
            
            // check for error
            guard (error == nil) else{
                complitionHandlerForPostLocation(nil, error)
                print("--------------error in-----postStudentLocation------ \(error)")
                return
            }
            
            if let data = result{
                complitionHandlerForPostLocation(data, nil)
            }
            else{
                complitionHandlerForPostLocation(nil, error)
            }
        }
        
    }
    
    //#MARK: - UPDATE student location
    func updateStudentLocation(_ objectID: String!, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, complitionHandlerForUpdateLocation: @escaping(_ result: AnyObject?, _ error: Error?)->Void){
        
        let jsonBody = "{\"\(StudentLocationKey.uniqueKey)\": \"\(uniqueKey)\", \"\(StudentLocationKey.firstName)\": \"\(firstName)\", \"\(StudentLocationKey.lastName)\": \"\(lastName)\",\"\(StudentLocationKey.mapString)\": \"\(mapString)\", \"\(StudentLocationKey.mediaURL)\": \"\(mediaUrl)\",\"\(StudentLocationKey.latitude)\": \(latitude), \"\(StudentLocationKey.longitude)\": \(longitude)}"
        
        let _ = taskForMutableRequest(objectID, requestMethod: "PUT", parameters: nil, hostName: Constents.ParseHostName, pathName: Constents.ParseAPIPath, jsonBody: jsonBody, needParseValues: true, needHeaderValues: true, needOriginalData: false) { (result, originalData, error) in
            // check for error
            guard (error == nil) else{
                complitionHandlerForUpdateLocation(nil, error)
                return
            }
            
            if let data = result{
                complitionHandlerForUpdateLocation(data, nil)
            }
            else{
                complitionHandlerForUpdateLocation(nil, error)
            }
        }
    }
    
    
    
}
