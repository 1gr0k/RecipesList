//
//  RecepiesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

protocol RecepiesRepository {
    @discardableResult
    func fetchRecepiesList(query: RecipeQuery, offset: Int, number: Int,
                           cached: @escaping (RecepiesPage) -> Void,
                           completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable?
    func fetchFavouriteRecepiesList(query: FavouriteRecipesQuery,
                           completion: @escaping (Result<FavouriteRecipes, Error>) -> Void) -> Cancellable?
    func fetchRecipeDetails(query: DetailRecipeQuery,
//                            cached: @escaping (DetailRecipe) -> Void,
                            completion: @escaping (Result<DetailRecipe, Error>) -> Void) -> Cancellable?
}
