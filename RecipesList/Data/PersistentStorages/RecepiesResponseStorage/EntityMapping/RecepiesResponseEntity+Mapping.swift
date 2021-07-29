//
//  RecepiesResponseEntity+Mapping.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CoreData

extension RecepiesResponseEntity {
    func toDTO() -> RecipesResponseDTO {
        return .init(page: Int(page), totalPages: Int(totalPages), recepies: recepies?.allObjects.map { ($0 as! ReceptResponseEntity).toDTO() } ?? [])
    }
}

extension ReceptResponseEntity {
    func toDTO() -> RecipesResponseDTO.ReceptDTO {
        return .init(id: Int(id),
                     title: title,
                     image: image)
    }
}

extension RecipesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RecipesRequestEntity {
        let entity: RecipesRequestEntity = .init(context: context)
        entity.query = query
        entity.offset = Int32(offset)
        entity.number = Int32(number)
        return entity
    }
}

extension RecipesResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> RecepiesResponseEntity {
        let entity: RecepiesResponseEntity = .init(context: context)
        entity.page = Int32(page)
        entity.totalPages = Int32(totalPages)
        recepies.forEach {
            entity.addToRecepies($0.toEntity(in: context))
        }
        return entity
    }
}
