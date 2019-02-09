//
//  TwoSizeLabel.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 08.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import UIKit

class TwoSizeLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text,
                let separatorIndex = text.lastIndex(of: ".") else {
                    return
            }
            
            let myRange = NSRange(location: separatorIndex.encodedOffset, length: text.count - separatorIndex.encodedOffset)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: font.pointSize/1.25)], range: myRange)
            self.attributedText = attributedText
        }
    }
}
