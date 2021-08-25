//
//  RecepiesResponseDTO.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CloudKit

struct RecipesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page = "offset"
        case totalPages = "totalResults"
        case recepies = "results"
    }
    let page: Int
    let totalPages: Int
    let recepies: [ReceptDTO]
    
}

extension RecipesResponseDTO {
    struct ReceptDTO: Decodable {
        let id: Int
        let title: String?
        let image: String?
    }
}

extension RecipesResponseDTO {
    func toDomain() -> RecepiesPage {
        let page = page/DefaultRecipesListViewModel.itemsPerPage
        let totalPages = totalPages/DefaultRecipesListViewModel.itemsPerPage
        return .init(page: page, totalPages: totalPages, recepies: recepies.map { $0.toDomain()})
    }
}

extension RecipesResponseDTO.ReceptDTO {
    func toDomain() -> Recipe {
        return .init(id: Recipe.Identifier(id), title: self.title, image: self.image, favourite: false)
    }
}


