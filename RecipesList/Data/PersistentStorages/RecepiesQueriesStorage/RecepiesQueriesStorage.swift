//
//  RecepiesQueriesStorage.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol RecepiesQueriesStorage {
    func fetchRecentQueries(maxCount: Int, completion: @escaping (Result<[RecipeQuery], Error>) -> Void)
    func saveRecentQuery(query: RecipeQuery, completion: @escaping (Result<RecipeQuery, Error>) -> Void)
}
