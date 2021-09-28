//
//  ApiErrorViewModel.swift
//  ApiErrorViewModel
//
//  Created by Андрей Калямин on 15.09.2021.
//

import Foundation

protocol ApiErrorViewModelInput {
    func setApi(api: String)
}

protocol ApiErrorViewModel: ApiErrorViewModelInput {
    
}

class DefaultApiErrorViewModel: ApiErrorViewModel {
    
    
    func setApi(api: String) {
        AppDelegate.container.resolve(SetApiKeyInteractor.self)?.setApiKey(api: api)
    }
}
