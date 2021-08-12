//
//  CoreDataFavouriteRecipesStorege.swift
//  CoreDataFavouriteRecipesStorege
//
//  Created by Андрей Калямин on 03.08.2021.
//

import Foundation
import CoreData

final class CoreDataFavouriteRecipesStorage{
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func fetchRequest() -> NSFetchRequest<FavouriteRecipesEntity> {
        let request: NSFetchRequest = FavouriteRecipesEntity.fetchRequest()
        return request
    }
    
    private func fetchRequest(for requestDto: FavouriteRecipesDTO) -> NSFetchRequest<FavouriteRecipesEntity> {
        let request: NSFetchRequest = FavouriteRecipesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@",
                                        (\FavouriteRecipesEntity.id)._kvcKeyPathString!, requestDto.id)
        return request
    }
}

extension CoreDataFavouriteRecipesStorage: FavouriteRecipesStorage {
    func getFavourite(completion: @escaping (Result<FavouriteRecipes, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                
                                completion(.success(requestEntity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(for favoriteRecipeDto: FavouriteRecipesDTO, completion: @escaping () -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let _ = favoriteRecipeDto.toEntity(in: context)
                try context.save()
                completion()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    func remove(for favoriteRecipeDto: FavouriteRecipesDTO, completion: @escaping () -> Void) {
        coreDataStorage.performBackgroundTask { context in
            let request = self.fetchRequest(for: favoriteRecipeDto)
            
            do {
                let results = try context.fetch(request)
                for result in results {
                   try context.delete(result)
                }
                 } catch {
                      print("Failed")
                 }
                 do {
                     try context.save()
                     completion()
                 } catch {
                     print("Failed saving")
                 }
        }
    }
    
    
}
