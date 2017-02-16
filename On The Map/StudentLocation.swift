//
//  StudentLocations.swift
//  On The Map
//
//  Created by osmanjan omar on 2/10/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

//import Foundation

// creating a student location object with elements
struct StudentLocation {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    //initializing with results from network request
    init(dictionary: [String: AnyObject]) {
        if let objectID = dictionary[OnTheMapNetworking.StudentLocationKey.objectId] as? String,
            let uniqueKEY = dictionary[OnTheMapNetworking.StudentLocationKey.uniqueKey] as? String,
            let firstNAME = dictionary[OnTheMapNetworking.StudentLocationKey.firstName] as? String,
            let lastNAME  = dictionary[OnTheMapNetworking.StudentLocationKey.lastName]  as? String,
            let mapSTRING = dictionary[OnTheMapNetworking.StudentLocationKey.mapString] as? String,
            let mediaUrl  = dictionary[OnTheMapNetworking.StudentLocationKey.mediaURL]  as? String,
            let latiTUDE  = dictionary[OnTheMapNetworking.StudentLocationKey.latitude]  as? Double,
            let longiTUDE = dictionary[OnTheMapNetworking.StudentLocationKey.longitude] as? Double
        {
            objectId = objectID
            uniqueKey = uniqueKEY
            firstName = firstNAME
            lastName = lastNAME
            mapString = mapSTRING
            mediaURL = mediaUrl
            latitude = latiTUDE
            longitude = longiTUDE
            createdAt = dictionary[OnTheMapNetworking.StudentLocationKey.createdAt] as! String
            updatedAt = dictionary[OnTheMapNetworking.StudentLocationKey.updatedAt] as! String
        }
        else{
            objectId = ""
            uniqueKey = ""
            firstName = ""
            lastName = ""
            mapString = ""
            mediaURL = ""
            latitude = nil
            longitude = nil
            createdAt = ""
            updatedAt = ""
        }
    }
    
    
    
    // take data as parameter and create a student location object
    static func studentInfoFromDictionary(_ results: [[String: AnyObject]])->[StudentLocation]{
        
        var studentLocations = [StudentLocation]()
        for result in results{
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
        
    }
        
}

extension StudentLocation: Equatable{}

func == (lhs: StudentLocation, rhs: StudentLocation) ->Bool{
    return lhs == rhs
}
    


