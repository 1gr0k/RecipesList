//
//  SearchReceptUseCase.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol SearchRecepiesUseCase {
    func execute(requestValue: SearchRecepiesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchRecepiesUseCase: SearchRecepiesUseCase {
    
    private let recipiesRepository: RecepiesRepository
    private let recepiesQueriesRepository: RecepiesQueriesRepository
    
    init(recepiesRepository: RecepiesRepository,
         recepiesQueriesRepository: RecepiesQueriesRepository) {
        
        self.recipiesRepository = recepiesRepository
        self.recepiesQueriesRepository = recepiesQueriesRepository
    }
    
    func execute(requestValue: SearchRecepiesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable? {

        return recipiesRepository.fetchRecepiesList(query: requestValue.query,
                                                page: requestValue.page,
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
    let query: ReceptQuery
    let page: Int
}
