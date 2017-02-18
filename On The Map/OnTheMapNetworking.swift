//
//  OnTheMapNetworking.swift
//  On The Map
//
//  Created by osmanjan omar on 2/1/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation
import UIKit

class OnTheMapNetworking: NSObject {
    
    //shared Instance
    static let SharedInstance: OnTheMapNetworking = {
        let instance = OnTheMapNetworking()
        return instance
    }()
    
    // shared session
    var session = URLSession.shared
    
    //initializing
    override init(){
        super.init()
    }
    
    //#MARK: - GET URL request
    func taskForGETMethod(_ method: String?, _ parameters: [String: AnyObject]?, hostName: String?, pathName: String?, needParseValues: Bool, needHeaderValues: Bool, needOriginalData: Bool, complitionHandlerForGET: @escaping(_ result:AnyObject?, _ data: Data?, _ error: NSError?)->Void)->URLSessionDataTask {
        
        //set parameters
        let url = URLFromComponents(parameters, hostName: hostName!, pathName: pathName!, withPathExtension: method)
        let request = requestForReuse(url, requestMethod: "GET", addParseValues: needParseValues, addValueToRequest: needHeaderValues)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                complitionHandlerForGET(nil, nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            //ckecking for error
            guard (error == nil) else {
                sendError("\(error)")
                return
            }
            
            //check Status code
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let theCode = (response as? HTTPURLResponse)?.statusCode
                sendError("\(error), \(theCode)")
                return
            }
            
            guard let data = data else {
                sendError("\(error)")
                return
            }
            
            self.parseDataWithComplitionHandler(data, passOriginalData: needOriginalData, complitionHandlerForConvertData: complitionHandlerForGET)
        }
        
        task.resume()
        return task
    }
    
    //#MARK: -Task for POST/PUT/DELETE
    
    func taskForMutableRequest(_ method: String?, requestMethod: String ,parameters: [String: AnyObject]?, hostName: String?, pathName: String?, jsonBody: String?, needParseValues: Bool, needHeaderValues: Bool, needOriginalData: Bool, complitionHandlerForMutableRequest: @escaping(_ result: AnyObject?, _ originaldata: Data? ,_ error: Error?)->Void)->URLSessionDataTask {
        
        let request = requestForReuse(URLFromComponents(parameters, hostName: hostName!, pathName: pathName!, withPathExtension: method), requestMethod: requestMethod, addParseValues: needParseValues, addValueToRequest: needHeaderValues)
        
        request.httpBody = jsonBody?.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                complitionHandlerForMutableRequest(nil, nil, NSError(domain: "taskFor\(requestMethod)Method", code: 1, userInfo: userInfo))
            }
            //ckecking for error
            guard (error == nil) else {
                sendError("----net work error \(error)")
                return
            }
            
            //check Status code
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let theCode = (response as? HTTPURLResponse)?.statusCode
                sendError("--------status code not in range for \(requestMethod) request------ \(error), \(theCode)")
                
                return
            }
            
            if let data = data {
                
                self.parseDataWithComplitionHandler(data, passOriginalData: needOriginalData, complitionHandlerForConvertData: complitionHandlerForMutableRequest)
            }
            else{
                sendError("----no data found\(error)")
                return
            }
            
        }
        
        task.resume()
        return task
    }
    
}


extension OnTheMapNetworking{
    
    func URLFromComponents(_ parameters: [String: AnyObject]?, hostName: String, pathName: String ,withPathExtension: String?)->URL {
        
        var components = URLComponents()
        components.scheme = Constents.APIScheme
        components.host = hostName
        components.path = pathName + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value:"\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    //making reusable network request
    func requestForReuse(_ url: URL, requestMethod: String, addParseValues: Bool, addValueToRequest: Bool) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = requestMethod
        //checking if parse API key value needed
        if addParseValues == true{
            request.addValue(ParametersValue.APIKey, forHTTPHeaderField: ParametersKey.APIKey)
            request.addValue(ParametersValue.ApplicationID, forHTTPHeaderField: ParametersKey.ApplicationID)
        }
        //checking if need to add value to header field
        if addValueToRequest == true{
            request.addValue(Constents.ApplicationJson, forHTTPHeaderField: Constents.Accept)
            request.addValue(Constents.ApplicationJson, forHTTPHeaderField: Constents.ContentType)
        }
        return request
    }
    
    //helper function that parses json data
    fileprivate func parseDataWithComplitionHandler(_ data: Data, passOriginalData: Bool ,complitionHandlerForConvertData: (_ result:AnyObject?, _ originaldata: Data? ,_ error: NSError?)->Void){
        
        if passOriginalData == true {
            complitionHandlerForConvertData(nil, data, nil)
        }
        else{
            
            //let stringData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            //let newData = stringData.data(using: String.Encoding.utf8.rawValue)
            var parsedData: AnyObject? = nil
            
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                let userInfo = [NSLocalizedDescriptionKey: error]
                complitionHandlerForConvertData(nil, data ,NSError(domain: "parseDataWithComplitionHandler", code: 1, userInfo: userInfo))
            }
            
            complitionHandlerForConvertData(parsedData, nil, nil)
        }
    }
    
    
    
}

