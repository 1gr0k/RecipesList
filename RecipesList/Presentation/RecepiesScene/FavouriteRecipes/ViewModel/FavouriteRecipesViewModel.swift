//
//  FavouriteRecipesViewModel.swift
//  FavouriteRecipesViewModel
//
//  Created by Андрей Калямин on 04.08.2021.
//

import Foundation
import InjectPropertyWrapper


protocol FavouriteRecipesViewModelInput {
    func viewDidload()
    func removeLike(id: String, title: String)
    func didSelectItem(at index: Int)
    func refresh()
    func viewDesappear()
    func setupActions(actions: RecepiesListViewModelActions)
}

protocol FavouriteRecipesViewModelOutput {
    var items: Observable<[FavouriteRecept]> { get }
    var loading: Observable<RecepiesListViewModelLoading?> { get }
    
}

protocol FavouriteRecipesViewModel: FavouriteRecipesViewModelOutput, FavouriteRecipesViewModelInput {}

class DefaultFavouriteRecipesViewModel: FavouriteRecipesViewModel {

    @Inject private var favouriteRecipesListUseCase: FavouriteRecipesListUseCase
    private var actions: RecepiesListViewModelActions?
    private var timer: Timer?
    @Inject private var removeLikeInteractor: RemoveLikeInteractor
    
    private var recepiesLoadTask: Cancellable? { willSet {recepiesLoadTask?.cancel() } }
    
    // MARK: Output
    let items: Observable<[FavouriteRecept]> = Observable([])
    let loading: Observable<RecepiesListViewModelLoading?> = Observable(.none)
    
    private func load(loading: RecepiesListViewModelLoading) {
        self.loading.value = loading
        favouriteRecipesListUseCase.execute(completion: { result in
            if case let .success(favouriteRecipe) = result {
                self.items.value = favouriteRecipe.recepies
                self.loading.value = .none
            } else {
                self.items.value = []
            }
        })
    }
    
    func setupActions(actions: RecepiesListViewModelActions) {
        self.actions = actions
    }
}

extension DefaultFavouriteRecipesViewModel {
    
    func viewDidload() {
        load(loading: .fullScreen)
    }
    
    func refresh() {
        load(loading: .fullScreen)
    }
}
extension DefaultFavouriteRecipesViewModel {
    func removeLike(id: String, title: String) {
        let index = self.items.value.firstIndex { $0.id == id }
        removeLikeInteractor.removeLike(id: id, completion: {
                self.items.value.remove(at: index!)
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.favouriteListChangedNotification), userInfo: nil, repeats: false)
                }
            })
    }
    
    @objc func favouriteListChangedNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeRecipeFromFavourite"), object: nil)
        timer = nil
    }
    
    internal func viewDesappear() {
        if timer != nil {
            timer?.invalidate()
            favouriteListChangedNotification()
        }
    }
}

extension DefaultFavouriteRecipesViewModel {
    func didSelectItem(at index: Int) {
        actions?.showRecipeDetails(items.value[index].id)
    }
}
