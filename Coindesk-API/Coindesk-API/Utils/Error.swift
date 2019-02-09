//
//  Error.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

enum RequestError: Error {
    case badFormatURL, noResponse, invalidResponse, invalidData
}

enum FormatError: Error {
    case badFormatError
}

enum NetworkError: Error {
    case noInternet
    
    var title: String {
        switch self {
        case .noInternet: return "No internet"
        }
    }
    
    var message: String {
        switch self {
        case .noInternet: return "Please verify your connection. You cannot download new data without an internet connection."
        }
    }
}
