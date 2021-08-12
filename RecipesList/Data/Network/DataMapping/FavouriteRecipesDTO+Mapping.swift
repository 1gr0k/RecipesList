//
//  FavouriteRecipesDTO+Mapping.swift
//  FavouriteRecipesDTO+Mapping
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation

struct FavouriteRecipesDTO: Encodable {
    let id: String
    
    func toDomain() ->String {
        return ""
    }
}
