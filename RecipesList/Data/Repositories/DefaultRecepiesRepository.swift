//
//  DefaultRecepiesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import InjectPropertyWrapper

final class DefaultRecepiesRepository {
    @Inject(name: "apiDataTransferService") private var dataTransferService: DataTransferService
    @Inject private var cache: RecipesResponseStorage

}

extension DefaultRecepiesRepository: RecepiesRepository {
    
    func fetchRecepiesList(query: RecipeQuery,
                           offset: Int,
                           number: Int,
                           cached: @escaping (RecepiesPage) -> Void,
                           completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = RecipesRequestDTO(query: query.query, offset: offset, number: number)
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getRecepies(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
    func fetchFavouriteRecepiesList(query: FavouriteRecipesQuery,
                                    completion: @escaping (Result<FavouriteRecipes, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = FavouriteRecipesRequestDTO(ids: query.query)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getRecipesListByIds(with: requestDTO)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    
    
    func fetchRecipeDetails(query: DetailRecipeQuery,
                            completion: @escaping (Result<DetailRecipe, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = RecipeDetailsRequestDTO(recipeId: query.query)
        let task = RepositoryTask()
        
        cache.getDetailsResponse(for: requestDTO) { result in
            
            guard !task.isCancelled else { return }
            let endpoint = APIEndpoints.getRecipeDetails(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
