//
//  ApiErrorViewModel.swift
//  ApiErrorViewModel
//
//  Created by Андрей Калямин on 15.09.2021.
//

import Foundation
import InjectPropertyWrapper

protocol ApiErrorViewModelInput {
    func setApi(api: String)
}

protocol ApiErrorViewModel: ApiErrorViewModelInput {
    
}

class DefaultApiErrorViewModel: ApiErrorViewModel {
    
    @Inject private var setApiKeyInteractor: SetApiKeyInteractor
    
    
    func setApi(api: String) {
        setApiKeyInteractor.setApiKey(api: api)
    }
    
}
