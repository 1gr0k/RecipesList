//
//  RecepiesResponseStorage.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol RecipesResponseStorage {
    func getResponse(for request: RecipesRequestDTO, completion: @escaping (Result<RecipesResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: RecipesResponseDTO, for requestDto: RecipesRequestDTO)
    func getDetailsResponse(for request: RecipeDetailsRequestDTO, completion: @escaping (Result<RecipeDetailsResponseDTO?, CoreDataStorageError>) -> Void)
}
