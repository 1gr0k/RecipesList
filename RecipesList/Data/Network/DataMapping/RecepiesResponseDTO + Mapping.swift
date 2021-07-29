//
//  RecepiesResponseDTO.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CloudKit

struct RecepiesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page = "offset"
        case totalPages = "totalResults"
        case recepies = "results"
    }
    let page: Int
    let totalPages: Int
    let recepies: [ReceptDTO]
    
}

extension RecepiesResponseDTO {
    struct ReceptDTO: Decodable {
        let id: Int
        let title: String?
        let image: String?
    }
}

extension RecepiesResponseDTO {
    func toDomain() -> RecepiesPage {
        let page = page/10
        let totalPages = totalPages/10
        return .init(page: page, totalPages: totalPages, recepies: recepies.map { $0.toDomain()})
    }
}

extension RecepiesResponseDTO.ReceptDTO {
    func toDomain() -> Recept {
        return .init(id: Recept.Identifier(id), title: self.title, image: self.image)
    }
}


