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
        return .init(page: 1, totalPages: 1, recepies:[RecepiesResponseDTO.ReceptDTO.init(id: 1, title: "asd")] )
//        return .init(page: Int(page),
//                     totalPages: Int(totalPages),
//                     recepies: recepies?.allObjects.map { ($0 as! RecepiesResponseEntity).toDTO() } ?? [])
    }
}

extension ReceptResponseEntity {
    func toDTO() -> RecepiesResponseDTO.ReceptDTO {
        return .init(id: Int(id),
                     title: title)
//                     genre: MoviesResponseDTO.MovieDTO.GenreDTO(rawValue: genre ?? ""),
//                     posterPath: posterPath,
//                     overview: overview,
//                     releaseDate: releaseDate)
    }
}

extension RecepiesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> RecepiesRequestEntity {
        let entity: RecepiesRequestEntity = .init(context: context)
        entity.query = query
        entity.page = Int32(page)
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

//extension RecepiesResponseDTO.ReceptDTO {
//    func toEntity(in context: NSManagedObjectContext) -> ReceptResponseEntity {
//        let entity: ReceptResponseEntity = .init(context: context)
//        entity.id = Int64(id)
//        entity.title = title
////        entity.genre = genre?.rawValue
////        entity.posterPath = posterPath
////        entity.overview = overview
////        entity.releaseDate = releaseDate
//        return entity
//    }
//}
