//
//  Error.swift
//  Coindesk-API
//
//  Created by Cédric Rolland on 06.02.19.
//  Copyright © 2019 Cédric Rolland. All rights reserved.
//

protocol DetailedError: Error {
    var title: String { get }
    var message: String { get }
}

enum RequestError: DetailedError {
    case badFormatURL, invalidResponse
    
    var title: String {
        return "Request Error"
    }
    
    var message: String {
        switch self {
        case .badFormatURL: return "We could get the data, the URL is invalid."
        case .invalidResponse: return "We received an invalid response from the server."
        }
    }
}

enum DataError: DetailedError {
    case badFormat
    case noOfflineData
    
    var title: String {
        return "Data Error"
    }
    
    var message: String {
        switch self {
        case .badFormat: return "We received invalid data from the server."
        case .noOfflineData: return "There is no data stored on the device."
        }
    }
}

enum NetworkError: DetailedError {
    case noInternet
    
    var title: String {
        return "No internet"
    }
    
    var message: String {
        return "Please verify your connection. You cannot download new data without an internet connection."
    }
}

enum UnknowError: DetailedError {
    case unexpectedError
    
    var title: String {
        return "Error"
    }
    
    var message: String {
        return "An unexpected error occurred."
    }
}
