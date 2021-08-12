//
//  FavouriteRecipesStorage.swift
//  FavouriteRecipesStorage
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation

protocol FavouriteRecipesStorage {
    func getFavourite(completion: @escaping (Result<FavouriteRecipes, CoreDataStorageError>) -> Void)
    func  save(for favoriteRecipeDto: FavouriteRecipesDTO, completion: @escaping () -> Void)
    func remove(for favoriteRecipeDto: FavouriteRecipesDTO, completion: @escaping () -> Void)
}
