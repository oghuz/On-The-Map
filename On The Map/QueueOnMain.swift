//
//  UIUpdatesOnMain.swift
//  On The Map
//
//  Created by osmanjan omar on 2/7/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//

import Foundation

func uiupdateOnMainQueue(_ update: @escaping ()->Void){

    DispatchQueue.main.async {
        update()
    }
}
