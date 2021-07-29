//
//  DefaultRecepiesRepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

final class DefaultRecepiesRepository {
    private let dataTransferService: DataTransferService
    private let cache: RecepiesResponseStorage
    
    init(dataTransferService: DataTransferService, cache: RecepiesResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultRecepiesRepository: RecepiesRepository {
    
    func fetchRecepiesList(query: ReceptQuery,
                           offset: Int,
                           number: Int,
                           cached: @escaping (RecepiesPage) -> Void,
                           completion: @escaping (Result<RecepiesPage, Error>) -> Void) -> Cancellable? {
        
        let requestDTO = RecepiesRequestDTO(query: query.query, offset: offset, number: number)
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
}
