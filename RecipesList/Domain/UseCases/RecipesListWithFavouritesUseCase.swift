//
//  FavoritesRecipesUseCase.swift
//  FavoritesRecipesUseCase
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation
import InjectPropertyWrapper

protocol RecipesListWithFavouritesUseCase {
    func execute(requestValue: FavoritesRecipesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable?
}

final class DefaultFavoritesRecipesUseCase: RecipesListWithFavouritesUseCase {
    
    @Inject private var recipiesRepository: RecepiesRepository
    @Inject private var recepiesQueriesRepository: RecepiesQueriesRepository
    
    @Inject private var getAllLikesInteractor : GetAllLikesInteractor
    
    private var favourites: FavouriteRecipes?
    
    func execute(requestValue: FavoritesRecipesUseCaseRequestValue,
                 cached: @escaping (RecepiesPage) -> Void,
                 completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable? {
        
        getAllLikesInteractor.getFavourite { result in
            if case let .success(favouriteRecipes) = result {
                self.favourites = favouriteRecipes
            }
        }
        
        return recipiesRepository.fetchRecepiesList(query: requestValue.query,
                                                    offset: requestValue.offset,
                                                    number: requestValue.number,
                                                    cached: cached,
                                                    completion: { result in
            var resultWithFav = result
            if case .success = result {
            resultWithFav = result.map { recipesPage in
                    RecepiesPage(page: recipesPage.page, totalPages: recipesPage.totalPages, recepies: recipesPage.recepies.map { recept in
                        Recipe(id: recept.id, title: recept.title, image: recept.image, favourite: self.checkRecept(id: recept.id))
                    })
                }
            }
            completion(resultWithFav)
        })
    }
    
    func checkRecept(id: String) -> Bool {
        guard let favourites = self.favourites?.recepies else { return false }
        return favourites.contains { $0.id == id }
    }
}



struct FavoritesRecipesUseCaseRequestValue {
    let query: RecipeQuery
    let offset: Int
    let number: Int = 10
    
    init(query: RecipeQuery, page: Int) {
        self.query = query
        self.offset = page*10
    }
}
