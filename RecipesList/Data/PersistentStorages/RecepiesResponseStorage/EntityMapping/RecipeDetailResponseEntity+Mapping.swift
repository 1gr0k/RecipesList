//
//  RecipeDetailResponseEntity.swift
//  RecipesList
//
//  Created by Андрей Калямин on 23.07.2021.
//

import Foundation
import CoreData

extension RecipeDetailsResponseEntity {
    func toDTO() -> RecipeDetailsResponseDTO {
        return .init(id: Int(id),
                     title: title ?? "",
                     image: image ?? "",
                     readyInMinutes: 0,
                     dishTypes: dishTypes?.allObjects.compactMap {$0 as? String } ?? [],
                     extendedIngredients: extendedIngredients?.allObjects.map { ($0 as! ExtendedIngredientsResponseEntity).toDTO() } ?? [])
    }
}

extension ExtendedIngredientsResponseEntity {
    func toDTO() -> RecipeDetailsResponseDTO.ExtIngredientDTO {
        return .init(id: Int(id), name: name ?? "")
    }
}
