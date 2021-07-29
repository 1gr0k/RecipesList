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
