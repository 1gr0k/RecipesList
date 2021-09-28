//
//  RemoveLikeInteractor.swift
//  RemoveLikeInteractor
//
//  Created by Андрей Калямин on 09.08.2021.
//

import Foundation
import InjectPropertyWrapper

class RemoveLikeInteractor {
    
    @Inject private var favouriteRecepiesStorage: FavouriteRecipesStorage

    func removeLike(id: String, completion: @escaping () ->Void) {
        
        favouriteRecepiesStorage.remove(for: FavouriteRecipesDTO(id: id)) {
            completion()
        }
    }
}
