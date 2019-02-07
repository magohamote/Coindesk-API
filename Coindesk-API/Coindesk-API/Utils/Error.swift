//
//  Error.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

enum RequestError: Error {
    case badFormatURL
    case noResponse
    case invalidResponse
    case invalidData
}

enum FormatError: Error {
    case badFormatError
}
