//
//  FavouriteRecipesViewModel.swift
//  FavouriteRecipesViewModel
//
//  Created by Андрей Калямин on 04.08.2021.
//

import Foundation


protocol FavouriteRecipesViewModelInput {
    func viewDidload()
    func didLoadNextPage()
    func removeLike(id: String, title: String)
}

protocol FavouriteRecipesViewModelOutput {
    var items: Observable<[FavouriteRecept]> { get }
    var loading: Observable<RecepiesListViewModelLoading?> { get }
//    var query: Observable<String> { get }
//    var error: Observable<String> { get }
    
}

protocol FavouriteRecipesViewModel: FavouriteRecipesViewModelOutput, FavouriteRecipesViewModelInput {}

class DefaultFavouriteRecipesViewModel: FavouriteRecipesViewModel {
    
    
    
    private var favouriteRecipesListUseCase: FavouriteRecipesListUseCase
    private let removeLikeInteractor: RemoveLikeInteractor?
    
    private var recepiesLoadTask: Cancellable? { willSet {recepiesLoadTask?.cancel() } }
    
    // MARK: Output
    let items: Observable<[FavouriteRecept]> = Observable([])
    let loading: Observable<RecepiesListViewModelLoading?> = Observable(.none)
//    let query: Observable<String> = Observable("")
//    let error: Observable<String> = Observable("")
    
    init(favouriteRecipesListUseCase: FavouriteRecipesListUseCase, removeLikeInteractor: RemoveLikeInteractor) {
        self.favouriteRecipesListUseCase = favouriteRecipesListUseCase
        self.removeLikeInteractor = removeLikeInteractor
    }
    
    private func load(loading: RecepiesListViewModelLoading) {
        self.loading.value = loading
        favouriteRecipesListUseCase.execute(completion: { result in
            if case let .success(favouriteRecipe) = result {
                self.items.value = favouriteRecipe.recepies
            }
        })
    }
}

extension DefaultFavouriteRecipesViewModel {
    
    func viewDidload() {
        load(loading: .fullScreen)
    }
    
    func didLoadNextPage() {
        print("loadNextPage")
    }
}
extension DefaultFavouriteRecipesViewModel {
    func removeLike(id: String, title: String) {
        let index = self.items.value.firstIndex(of: FavouriteRecept(id: id, title: title))
        removeLikeInteractor?.removeLike(id: id, completion: {
            print("delete like")
        })
        
        self.items.value.remove(at: index!)
    }
}
