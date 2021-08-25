//
//  RemoveLikeInteractor.swift
//  RemoveLikeInteractor
//
//  Created by Андрей Калямин on 09.08.2021.
//

import Foundation

class RemoveLikeInteractor {
    private let favouriteRecipesStorage: FavouriteRecipesStorage
    
    init(favouriteRecipesStorage: FavouriteRecipesStorage) {
        self.favouriteRecipesStorage = favouriteRecipesStorage
    }
    func removeLike(id: String, completion: @escaping () ->Void) {
        favouriteRecipesStorage.remove(for: FavouriteRecipesDTO(id: id)) {
            completion()
        }
    }
}
