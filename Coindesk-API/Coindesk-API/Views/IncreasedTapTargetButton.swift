//
//  IncreasedTapTargetButton.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 09.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class IncreasedTapTargetButton: UIButton {
    private func edgeInsetsInvert(insets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
    }
    
    private func extendedTapTargetInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedRect = bounds.inset(by: edgeInsetsInvert(insets: extendedTapTargetInsets()))
        if extendedRect.contains(point) {
            return true
        }
        
        return super.point(inside: point, with: event)
    }
}
