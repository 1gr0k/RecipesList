//
//  SetLikeInteractor.swift
//  SetLikeInteractor
//
//  Created by Андрей Калямин on 06.08.2021.
//

import Foundation

class SetLikeInteractor {
    private let favouriteRecipesStorage: FavouriteRecipesStorage
    
    init(favouriteRecipesStorage: FavouriteRecipesStorage) {
        self.favouriteRecipesStorage = favouriteRecipesStorage
    }
    func setLike(id: String, completion: @escaping () ->Void) {
        favouriteRecipesStorage.save(for: FavouriteRecipesDTO(id: id)) {
            completion()
        }
    }
}
