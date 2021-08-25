//
//  FavouriteRecipesResponseDTO+<apping.swift
//  FavouriteRecipesResponseDTO+<apping
//
//  Created by Андрей Калямин on 05.08.2021.
//

import Foundation

struct FavouriteRecipesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case recepies = ""
    }
    let recepies: [FavouriteReceptDTO]
    
}

extension FavouriteRecipesResponseDTO {
    struct FavouriteReceptDTO: Decodable {
        let id: Int
        let title: String?
    }
}

extension Array where Element == FavouriteRecipesResponseDTO.FavouriteReceptDTO {
    func toDomain() -> FavouriteRecipes {
        .init(recepies: self.map {
                FavouriteRecept(id: String($0.id), title: $0.title)
        })
    }
}
