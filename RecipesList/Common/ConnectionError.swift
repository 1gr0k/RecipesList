//
//  ConnectionError.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
    var isAuthorized: Bool { get }
    var isAvaliableRequests: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
    
    var isApiKeyError: Bool {
        guard let error = self as? ConnectionError, error.isAuthorized else {
            return false
        }
        return true
    }
    
    var isApiKeyAvaliableRequests: Bool {
        guard let error = self as? ConnectionError, error.isAvaliableRequests else {
            return false
        }
        return true
    }
}
