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
        let page = page/10
        let totalPages = totalPages/10

        let favouriteList : [String] = [] //через функцию получу текущий список избранного

        return .init(page: page, totalPages: totalPages, recepies: recepies.map { $0.toDomain(favouriteList: favouriteList)})
    }
}

extension RecepiesResponseDTO.ReceptDTO {
    func toDomain(favouriteList: [String]) -> Recept {
        let favourite = favouriteList.contains { $0 == String(self.id)}
        return .init(id: Recept.Identifier(id), title: self.title, image: self.image, favourite: favourite)
    }
}


