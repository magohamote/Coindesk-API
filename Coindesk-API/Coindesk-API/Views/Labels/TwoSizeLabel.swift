//
//  TwoSizeLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 08.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class TwoSizeLabel: AdjustableLabel {
    
    private var textStyle: UIFont.TextStyle?
    
    func apply(textStyle: UIFont.TextStyle) {
        self.textStyle = textStyle
    }

    override var text: String? {
        didSet {
            guard let text = text,
                let separatorIndex = text.lastIndex(of: "."),
                let textStyle = textStyle else {
                    return
            }
            
            let startRange = NSRange(location: 0, length: separatorIndex.encodedOffset)
            let endRange = NSRange(location: separatorIndex.encodedOffset, length: text.count - separatorIndex.encodedOffset)
            
            let startFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: textStyle).pointSize))
            let endFont = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: textStyle).pointSize/1.25))
            
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes([NSAttributedString.Key.font: startFont], range: startRange)
            attributedText.addAttributes([NSAttributedString.Key.font: endFont], range: endRange)
            
            self.attributedText = attributedText
        }
    }
    
    func noRate() {
        attributedText = nil
        text = "-"
    }
}
