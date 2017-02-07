//
//  OnTheMapNetworking.swift
//  On The Map
//
//  Created by osmanjan omar on 2/1/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapNetworking: NSObject{
    
    //shared Instance
    static let SharedInstance: OnTheMapNetworking = {
        let instance = OnTheMapNetworking()
        return instance
    }()
    
    // shared session
    var session = URLSession.shared
    
    override init(){
        super.init()
    }
    
    //#MARK: - GET URL request
    func taskForGETMethod(_ method: String, _ parameters: [String: AnyObject]?, hostName: String?, pathName: String?, needParseValues: Bool,complitionHandlerForGET: @escaping(_ result:AnyObject?, _ error: NSError?)->Void)->URLSessionDataTask{
        
        //set parameters
        
        let request = requestForReuse(URLFromComponents(parameters, hostName: hostName!, pathName: pathName!, withPathExtension: method), requestMethod: "GET", addParseValues: needParseValues)
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                complitionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            //ckecking for error
            guard (error == nil) else{
                Alert.SharedInstance.alert("Network Error", message: "\(error)", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            }
            
            //check Status code
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                Alert.SharedInstance.alert("Network Error", message: "network status code error", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            }
            
            guard let data = data else{
            
                Alert.SharedInstance.alert("Network Error", message: "No data was returned", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            
            }
            
            self.parseDataWithComplitionHandler(data, complitionHandlerForConvertData: complitionHandlerForGET)
            
        }
        
        task.resume()
        return task
    }
    
    //#MARK: -Task for POST/PUT/DELETE
    
    func taskForMutableRequest(_ method: String, requestMethod: String ,parameters: [String: AnyObject]?, hostName: String?, pathName: String?, jsonBody: String?, needParseValues: Bool ,complitionHandlerForMutableRequest: @escaping(_ result: AnyObject?, _ error: Error?)->Void)->URLSessionDataTask{
    
        let request = requestForReuse(URLFromComponents(parameters, hostName: hostName!, pathName: pathName!, withPathExtension: method), requestMethod: requestMethod, addParseValues: needParseValues)
        
        request.httpBody = jsonBody?.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                complitionHandlerForMutableRequest(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            //ckecking for error
            guard (error == nil) else{
                Alert.SharedInstance.alert("Network Error", message: "\(error)", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            }
            
            //check Status code
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                Alert.SharedInstance.alert("Network Error", message: "network status code error", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            }
            
            guard let data = data else{
                Alert.SharedInstance.alert("Network Error", message: "No data was returned", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
                sendError(error as! String)
                return
            }
            
            self.parseDataWithComplitionHandler(data, complitionHandlerForConvertData: complitionHandlerForMutableRequest)
        }
        
        task.resume()
        return task
    }
    
}


extension OnTheMapNetworking{
    
    func URLFromComponents(_ parameters: [String: AnyObject]?, hostName: String, pathName: String ,withPathExtension: String?)->URL{
        
        var components = URLComponents()
        components.scheme = Constents.APIScheme
        components.host = hostName
        components.path = pathName + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters{
            for (key, value) in parameters{
                let queryItem = URLQueryItem(name: key, value:"\(value)")
                components.queryItems!.append(queryItem)
                
            }
        }
        return components.url!
    }
    
    
    //making reusable network request
    func requestForReuse(_ url: URL, requestMethod: String, addParseValues: Bool) -> NSMutableURLRequest {
        let request = NSMutableURLRequest.init(url: url)
        request.httpMethod = requestMethod
        //checking if parse API key value needed
        if addParseValues == true{
        request.addValue(ParametersValue.APIKey, forHTTPHeaderField: ParametersKey.APIKey)
        request.addValue(ParametersValue.ApplicationID, forHTTPHeaderField: ParametersKey.ApplicationID)
        }
        
        request.addValue(Constents.ApplicationJson, forHTTPHeaderField: Constents.Accept)
        request.addValue(Constents.ApplicationJson, forHTTPHeaderField: Constents.ContentType)

        
        return request
    }
    
    //helper function that parses json data
    func parseDataWithComplitionHandler(_ data: Data, complitionHandlerForConvertData: (_ result:AnyObject?, _ error: NSError?)->Void){
        
        var parsedData: AnyObject? = nil
        
        do {
            try parsedData = JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            Alert.SharedInstance.alert("No data found", message: "Error while converting data", cancel: "Cancel", ok: "OK", alertStyle: .alert, actionStyle: .default, complitionHandler: nil)
            let userInfo = [NSLocalizedDescriptionKey: error]
            complitionHandlerForConvertData(nil, NSError(domain: "parseDataWithComplitionHandler", code: 1, userInfo: userInfo))
        }
        
        complitionHandlerForConvertData(parsedData, nil)
        
    }

    
        
}

