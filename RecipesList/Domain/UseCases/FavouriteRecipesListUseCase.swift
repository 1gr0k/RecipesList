//
//  FavouriteRecipesListUseCase.swift
//  FavouriteRecipesListUseCase
//
//  Created by Андрей Калямин on 05.08.2021.
//

import Foundation
import InjectPropertyWrapper

enum FavouritesErros: Error {
    case EmptyList
}

protocol FavouriteRecipesListUseCase {
    func execute(completion: @escaping (Result<FavouriteRecipes, Error>) -> Void)
}

final class DefaultFavouriteRecipesListUseCase: FavouriteRecipesListUseCase {
    
    @Inject private var recipesRepository: RecepiesRepository
    private var result: FavouriteRecipes?
    private var requestValue: FavouriteRecipesQuery?
    
    @Inject private var getAllLikesInteractor: GetAllLikesInteractor
    
    func execute(completion: @escaping (Result<FavouriteRecipes, Error>) -> Void) {
        let queue = DispatchQueue(label: "getingFavouritesListQueue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        queue.sync {
            semaphore.wait()
            self.getAllLikesInteractor.getFavourite { result in
                if case let .success(favouriteRecept) = result {
                    self.result = favouriteRecept
                    semaphore.signal()
                }
            }
        }
        
        queue.sync {
            semaphore.wait()
            
            if self.result?.recepies.count == 0 {
                completion(Result.failure(FavouritesErros.EmptyList))
                semaphore.signal()
            } else {
            
            self.recipesRepository.fetchFavouriteRecepiesList(query: FavouriteRecipesQuery(favouriteRecipes: self.result!)) { result in
                if case .success(_) = result {
                    completion(result)
                    semaphore.signal()
                }
            }
            }
        }
    }
}
