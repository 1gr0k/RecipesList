//
//  RecepiesResponseStorage.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol RecepiesResponseStorage {
    func getResponse(for request: RecepiesRequestDTO, completion: @escaping (Result<RecepiesResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: RecepiesResponseDTO, for requestDto: RecepiesRequestDTO)
}
