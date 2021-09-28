//
//  GetFavouriteRecipesInteractor.swift
//  GetFavouriteRecipesInteractor
//
//  Created by Андрей Калямин on 05.08.2021.
//

import Foundation
import InjectPropertyWrapper

class GetAllLikesInteractor {
        
    @Inject private var favouriteRecipesStorage: FavouriteRecipesStorage

    func getFavourite(completion: @escaping (Result<FavouriteRecipes, CoreDataStorageError>) ->Void)  {
        favouriteRecipesStorage.getFavourite { result in
            if case .success(_) = result {
                completion(result)
            } else {
                completion(result)
            }
        }
    }
}
