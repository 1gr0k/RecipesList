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
    
    private let setApiKeyInteractor: SetApiKeyInteractor
    
    init(setApiKeyInteractor: SetApiKeyInteractor) {
        self.setApiKeyInteractor = setApiKeyInteractor
    }
    
    func setApi(api: String) {
        setApiKeyInteractor.setApiKey(api: api)
    }
}
