//
//  IBDesgnable.swift
//  On The Map
//
//  Created by osmanjan omar on 6/3/17.
//  Copyright © 2017 osmanjan omar. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable class DesignableUIView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}

@IBDesignable class DesignableTextView: UITextView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    
}
