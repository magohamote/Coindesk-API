//
//  UIColor+Hex.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    static var darkPurple = UIColor(rgb: 0x29314b)
    static var purple = UIColor(rgb: 0x434d77)
    static var lightGreen = UIColor(rgb: 0xa7f998)
    static var lightGreenFade = UIColor(rgb: 0xa7f998, alpha: 0.4)
    static var lightRed = UIColor(rgb: 0xfc97ad)
    static var lightRedFade = UIColor(rgb: 0xfc97ad, alpha: 0.25)
}
