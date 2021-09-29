//
//  SearchReceptUseCase.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import InjectPropertyWrapper

protocol SearchRecepiesUseCase {
    func execute(requestValue: SearchRecepiesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchRecepiesUseCase: SearchRecepiesUseCase {
    
    @Inject private var recipiesRepository: RecepiesRepository
    @Inject private var recepiesQueriesRepository: RecepiesQueriesRepository
    
    func execute(requestValue: SearchRecepiesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable? {
        
        return recipiesRepository.fetchRecepiesList(query: requestValue.query,
                                                    offset: requestValue.offset,
                                                    number: requestValue.number,
                                                    cached: cached,
                                                    completion: { result in
            
            if case .success = result {
                self.recepiesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }
            completion(result)
        })
    }
}



struct SearchRecepiesUseCaseRequestValue {
    let query: RecipeQuery
    let offset: Int
    let number: Int = 10
    
    init(query: RecipeQuery, page: Int) {
        self.query = query
        self.offset = page*10
    }
}
