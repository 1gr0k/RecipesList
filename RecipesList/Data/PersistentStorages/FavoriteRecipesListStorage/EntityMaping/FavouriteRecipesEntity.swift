//
//  FavouriteRecipesEntity.swift
//  FavouriteRecipesEntity
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation
import CoreData

extension FavouriteRecipesEntity {
    func toDomain() -> String {
        return id ?? ""
    }
    
    func toDTO() -> FavouriteRecipesDTO {
        return .init(id: id ?? "")
    }
}

extension FavouriteRecipesDTO {
    func toEntity(in context: NSManagedObjectContext) -> FavouriteRecipesEntity {
        let entity: FavouriteRecipesEntity = .init(context: context)
        entity.id = id
        return entity
    }
}

extension Array where Element == FavouriteRecipesEntity {
    func toDomain() -> FavouriteRecipes {
        .init(recepies: self.map{
            FavouriteRecept(id: $0.id!, title: nil, image: nil)
        })
    }
}
