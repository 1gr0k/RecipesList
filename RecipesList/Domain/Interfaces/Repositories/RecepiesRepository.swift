//
//  RecepiesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol RecepiesRepository {
    @discardableResult
    func fetchRecepiesList(query: ReceptQuery, offset: Int, number: Int,
                           cached: @escaping (RecepiesPage) -> Void,
                           completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable?
}
