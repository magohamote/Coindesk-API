//
//  GradientView.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    var colors: [UIColor]? {
        didSet {
            if let allColors = colors {
                gradientLayer.colors = allColors.map { $0.cgColor }
                gradientLayer.startPoint = .zero
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            } else {
                gradientLayer.colors = nil
            }
        }
    }
}

class PurpleGradientView: GradientView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        colors = [.purple, .darkPurple]
    }
}
