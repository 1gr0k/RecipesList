//
//  DefaultRecepiesQueriesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

final class DefaultRecepiesQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var recepiesQueriesPersistentStorage: RecepiesQueriesStorage
    
    init(dataTransferService: DataTransferService,
         recepiesQueriesPersistentStorage: RecepiesQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.recepiesQueriesPersistentStorage = recepiesQueriesPersistentStorage
    }
}

extension DefaultRecepiesQueriesRepository: RecepiesQueriesRepository {
    func fetchRecentQueries(maxCount: Int, completion: @escaping (Result<[ReceptQuery], Error>) -> Void) {
        return recepiesQueriesPersistentStorage.fetchRecentQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: ReceptQuery, completion: @escaping (Result<ReceptQuery, Error>) -> Void) {
        recepiesQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
