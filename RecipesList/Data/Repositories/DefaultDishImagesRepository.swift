//
//  DefaultDishImageRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 21.07.2021.
//

import Foundation

final class DefaultDishImagesRepository {
    
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultDishImagesRepository: DishImagesRepository {
    
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getDishImage(path: imagePath)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
