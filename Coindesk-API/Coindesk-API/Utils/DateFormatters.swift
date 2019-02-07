//
//  DateFormatters.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 07.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

import Foundation

class DateToStringFormatter: DateFormatter {
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StringToDateFormatter: DateFormatter {
    override init() {
        super.init()
        dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
