//
//  Constants.swift
//  On The Map
//
//  Created by osmanjan omar on 2/1/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation

extension OnTheMapNetworking {
    
    
    //constents
    struct Constents {
        static let APIScheme = "https"
        static let UdacityHostName = "www.udacity.com"
        static let ParseHostName = "parse.udacity.com"
        static let UdacityAPIPath = "/api/session"
        static let UdacityUserAPIPath = "/api/users/"
        static let ParseAPIPath = "/parse/classes/StudentLocation/"
        static let Account = "account"
        static let DidRegistered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let SessionID = "id"
        static let ExpirationDate = "expiration"
        static let ApplicationJson = "application/json"
        static let Accept = "Accept"
        static let Udacity = "udacity"
        static let ContentType = "Content-Type"
        static let UserName = "username"
        static let Passward = "password"
        
        //UDAcity login/Logout Auth URL
        static let UdacityAuthMethodURL = "https://www.udacity.com/api/session"
        
        //URL for Getting/Posting/Deleting/Updating Students location
        static let ParseLocationMethodURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        //Api id and suffex for facebook login/logout
        static let FaceBookApiID = "365362206864879"
        static let URLSuffex = "onthemap"
        
        //Request Method constents
        static let MethodGET = "GET"
        static let MethodPOST = "POST"
        static let MethodPUT = "PUT"
        static let MethodTypeDelete = "DELETE"

    }
    
    //parse api parameters
    struct ParametersKey {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
    }
    
    struct ParametersValue {
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    
    //keys for a student location object(a array of dictionary after parsing)
    struct StudentLocationKey {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
    
}
