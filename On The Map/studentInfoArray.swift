//
//  studentInfoArray.swift
//  On The Map
//
//  Created by osmanjan omar on 2/17/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation

class studentInfoArray {
    
    var studentInfo = [StudentLocation]()

    private init() {}
    
    static let sharedInstance = studentInfoArray()
    
}
