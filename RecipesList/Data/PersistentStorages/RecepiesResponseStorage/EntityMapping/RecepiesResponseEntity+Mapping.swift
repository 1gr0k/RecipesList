//
//  RecepiesResponseEntity+Mapping.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CoreData

extension RecepiesResponseEntity {
    func toDTO() -> RecepiesResponseDTO {
        return .init(page: Int(page), totalPages: Int(totalPages), recepies: recepies?.allObjects.map { ($0 as! ReceptResponseEntity).toDTO() } ?? [])
    }
}

extension ReceptResponseEntity {
    func toDTO() -> RecepiesResponseDTO.ReceptDTO {
        return .init(id: Int(id),
                     title: title,
                     image: image)
    }
}

extension RecepiesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RecepiesRequestEntity {
        let entity: RecepiesRequestEntity = .init(context: context)
        entity.query = query
        entity.offset = Int32(offset)
        entity.number = Int32(number)
        return entity
    }
}

extension RecepiesResponseDTO {
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
