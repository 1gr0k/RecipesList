//
//  RecipeDetailsResponseDTO+Mapping.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import Foundation

struct RecipeDetailsResponseDTO: Decodable {
    let id: Int
    let title: String
    let image: String
    let dishTypes: [String]
    let extendedIngredients: [ExtIngredientDTO]
}

extension RecipeDetailsResponseDTO {
    struct ExtIngredientDTO: Decodable {
        let id: Int
        let name: String
    }
}

extension RecipeDetailsResponseDTO {
    func toDomain() -> DetailRecipe {
        
        return .init(id: String(id),
                     title: title,
                     image: image,
                     dishTypes: dishTypes,
                     extendedIngredients: extendedIngredients.map { $0.toDomain() })
    }
}

extension RecipeDetailsResponseDTO.ExtIngredientDTO {
    func toDomain() -> ExtIngredient {
        return .init(id: id, name: name)
    }
}


