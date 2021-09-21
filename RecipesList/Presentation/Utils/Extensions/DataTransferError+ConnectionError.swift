//
//  DataTransferError+ConnectionError.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import Foundation


extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
    
    public var isAuthorized: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              case .unathorized = networkError else {
                return false
        }
        return true
    }
    
    public var isAvaliableRequests: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
              case .requestLimit = networkError else {
                return false
        }
        return true
    }
}

