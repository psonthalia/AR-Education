//
//  UIColor.swift
//  AR Education
//
//  Created by Howard Wang on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit

extension UIColor {
    enum Color: Int {
        case darkest = 0x022B3A,
        dark = 0x3A506B,
        med = 0x1D7874,
        bright = 0x5BC0BE,
        brightest = 0xADF5FF
    }
    
    convenience init(color: Color, opaque: CGFloat = 1.0) {
        let color = color.rawValue
        let red = (color & 0xFF0000) >> 16
        let green = (color & 0x00FF00) >> 8
        let blue = color & 0x0000FF
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: opaque)
    }
    
}


