//
//  ReceptQueryEntity.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CoreData

extension ReceptQueryEntity {
    convenience init(receptQuery: RecipeQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = receptQuery.query
        createdAt = Date()
    }
}

extension ReceptQueryEntity {
    func toDomain() -> RecipeQuery {
        return .init(query: query ?? "")
    }
}


extension RecipesResponseDTO.ReceptDTO {
    func toEntity(in context: NSManagedObjectContext) -> ReceptResponseEntity {
        let entity: ReceptResponseEntity = .init(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.image = image
        return entity
    }
}
