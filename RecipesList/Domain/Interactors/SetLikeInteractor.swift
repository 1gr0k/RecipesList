//
//  SetLikeInteractor.swift
//  SetLikeInteractor
//
//  Created by Андрей Калямин on 06.08.2021.
//

import Foundation
import InjectPropertyWrapper

class SetLikeInteractor {
    
    @Inject private var favouriteRecipesStorage: FavouriteRecipesStorage
    
    func setLike(id: String, completion: @escaping () ->Void) {
        favouriteRecipesStorage.save(for: FavouriteRecipesDTO(id: id)) {
            completion()
        }
    }
}
