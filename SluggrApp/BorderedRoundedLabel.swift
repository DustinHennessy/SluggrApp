//
//  BorderedRoundedLabel.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedRoundedView: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
}