//
//  CoreDataRecepiesResponseStorage.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import CoreData

final class CoreDataRecepiesResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    //MARK: - Private
    
    private func fetchRequest(for requestDto: RecepiesRequestDTO) -> NSFetchRequest<RecepiesRequestEntity> {
        let request: NSFetchRequest = RecepiesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(RecepiesRequestEntity.query), requestDto.query,
                                        #keyPath(RecepiesRequestEntity.offset), requestDto.offset)
        return request
    }
    
    private func deleteResponse(for requestDto: RecepiesRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
    
}

extension CoreDataRecepiesResponseStorage: RecepiesResponseStorage {
    func getResponse(for requestDto: RecepiesRequestDTO, completion: @escaping (Result<RecepiesResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(response responseDto: RecepiesResponseDTO, for requestDto: RecepiesRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
