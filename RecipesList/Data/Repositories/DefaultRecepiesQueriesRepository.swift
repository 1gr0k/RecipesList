//
//  DefaultRecepiesQueriesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

final class DefaultRecepiesQueriesRepository {
    
    private lazy var dataTransferService: DataTransferService = {
        AppDelegate.container.resolve(DataTransferService.self, name: "apiDataTransferService")!
    }()
    private lazy var recepiesQueriesPersistentStorage: RecepiesQueriesStorage = {
        AppDelegate.container.resolve(RecepiesQueriesStorage.self, name: "recepiesQueriesStorage")!
    }()
}

extension DefaultRecepiesQueriesRepository: RecepiesQueriesRepository {
    func fetchRecentQueries(maxCount: Int, completion: @escaping (Result<[RecipeQuery], Error>) -> Void) {
        return recepiesQueriesPersistentStorage.fetchRecentQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void) {
        recepiesQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
