//
//  DefaultRecepiesQueriesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import InjectPropertyWrapper

final class DefaultRecepiesQueriesRepository {
    
    @Inject(name: "apiDataTransferService") private var dataTransferService: DataTransferService
    @Inject private var recepiesQueriesPersistentStorage: RecepiesQueriesStorage
}

extension DefaultRecepiesQueriesRepository: RecepiesQueriesRepository {
    func fetchRecentQueries(maxCount: Int, completion: @escaping (Result<[RecipeQuery], Error>) -> Void) {
        return recepiesQueriesPersistentStorage.fetchRecentQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void) {
        recepiesQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
