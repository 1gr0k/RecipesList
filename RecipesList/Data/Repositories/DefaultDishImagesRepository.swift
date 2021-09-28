//
//  DefaultDishImageRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 21.07.2021.
//

import Foundation

final class DefaultDishImagesRepository {
    
    private lazy var dataTransferService: DataTransferService = {
        AppDelegate.container.resolve(DataTransferService.self, name: "imageDataTransferService")!
    }()
}

extension DefaultDishImagesRepository: DishImagesRepository {
    func fetchIngredientImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        let endpoint = APIEndpoints.getIngredientImage(path: imagePath)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, NetworkError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
    
    
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getRecipeImage(path: imagePath, imageSize: .small)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, NetworkError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
    
    func fetchDetailImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getRecipeImage(path: imagePath, imageSize: .large)
        let task = RepositoryTask()
            task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, NetworkError>) in

            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
