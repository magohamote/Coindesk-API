//
//  PaddedTwoSizeLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 09.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//
//  Inspired from: https://spin.atomicobject.com/2017/08/04/swift-extending-uilabel/

import UIKit

class PaddedTwoSizeLabel: TwoSizeLabel {
    private let padding = Design.marginSmall
    private lazy var textPadding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        invalidateIntrinsicContentSize()
        let insetRect = bounds.inset(by: textPadding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textPadding.top, left: -textPadding.left, bottom: -textPadding.bottom, right: -textPadding.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textPadding))
        layer.cornerRadius = Design.cornerRadius
        layer.masksToBounds = true
    }
}
