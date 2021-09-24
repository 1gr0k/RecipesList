//
//  setApiKeyInteractor.swift
//  setApiKeyInteractor
//
//  Created by Андрей Калямин on 15.09.2021.
//

import Foundation

class SetApiKeyInteractor {
    
    func setApiKey(api: String) {
        UserDefaults.standard.set(api, forKey: "api")
    }
}
