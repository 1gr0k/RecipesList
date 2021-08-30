//
//  RecepiesSceneDIContainer.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit
import SwiftUI

final class RecipesSceneDIContainer {
    
    struct Dependencies{
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    //MARK: - Persistent Storage
    lazy var recepiesQueriesStorage: RecepiesQueriesStorage = CoreDataRecepiesQueriesStorage(maxStorageLimit: 10)
    lazy var recepiesResponseCache: RecipesResponseStorage = CoreDataRecepiesResponseStorage()
    lazy var favouriteRecepiesStorage: FavouriteRecipesStorage = CoreDataFavouriteRecipesStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Interactors
    func makeGetAllLikesInteractor() -> GetAllLikesInteractor {
        return GetAllLikesInteractor(favouriteRecipesStorage: favouriteRecepiesStorage)
    }
    
    func makeSetLikeInteractor() -> SetLikeInteractor {
        return SetLikeInteractor(favouriteRecipesStorage: favouriteRecepiesStorage)
    }
    
    func makeRemoveLikeInteractor() -> RemoveLikeInteractor {
        RemoveLikeInteractor(favouriteRecipesStorage: favouriteRecepiesStorage)
    }
    
    //MARK: - Use Cases
    func makeSearchRecepiesUseCase() -> SearchRecepiesUseCase {
        return DefaultSearchRecepiesUseCase(recepiesRepository: makeRecepiesRepository(), recepiesQueriesRepository: makeRecepiesQueriesRepository())
    }
    
    func makeFavouritesRecipesUseCase() -> RecipesListWithFavouritesUseCase {
        return DefaultFavoritesRecipesUseCase(getFavouriteRecipesInteractor: makeGetAllLikesInteractor(),
                                              recepiesRepository: makeRecepiesRepository(),
                                              recepiesQueriesRepository: makeRecepiesQueriesRepository())
    }
    
    func makeFavouriteRecipesListUseCase() -> FavouriteRecipesListUseCase {
        return DefaultFavouriteRecipesListUseCase(getAllLikesInteractor: makeGetAllLikesInteractor(), recepiesRepository: makeRecepiesRepository())
    }
    
    //MARK: - Repositories
    func makeRecepiesRepository() -> RecepiesRepository {
        return DefaultRecepiesRepository(dataTransferService: dependencies.apiDataTransferService, cache: recepiesResponseCache)
    }
    
    func makeRecepiesQueriesRepository() -> RecepiesQueriesRepository {
        return DefaultRecepiesQueriesRepository(dataTransferService: dependencies.apiDataTransferService, recepiesQueriesPersistentStorage: recepiesQueriesStorage)
    }
    
    func makeDishImagesRepository() -> DishImagesRepository {
        return DefaultDishImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    
    //MARK: - Recipes List
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController {
        return RecepiesListViewController.create(with: makeRecepiesListViewModel(actions: actions), dishImagesRepository: makeDishImagesRepository())
    }
    
    func makeRecepiesListViewModel(actions: RecepiesListViewModelActions) -> RecepiesListViewModel {
        return DefaultRecipesListViewModel(favouriteRecipesUseCase: makeFavouritesRecipesUseCase(), actions: actions, setLikeInteractor: makeSetLikeInteractor(), removeLikeInteractor: makeRemoveLikeInteractor())
    }
    
    //MARK: - Favourites List
    
    func makeFavouriteRecipesViewController(actions: RecepiesListViewModelActions) -> UIViewController {
        
//                    let view = FavouriteRecipesListView(viewModelWrapper: FavouriteRecipesListViewModelWrapper(viewModel: makeFavouriteRecipesViewModel(actions: actions)), dishImagesRepository: makeDishImagesRepository())
//                    return UIHostingController(rootView: view)
//
        return FavouriteRecipesTableViewController.create(viewModel: makeFavouriteRecipesViewModel(actions: actions), dishImagesRepository: makeDishImagesRepository())
        
        
    }
    func makeFavouriteRecipesViewModel(actions: RecepiesListViewModelActions) -> FavouriteRecipesViewModel {
        return DefaultFavouriteRecipesViewModel(favouriteRecipesListUseCase: makeFavouriteRecipesListUseCase(), removeLikeInteractor: makeRemoveLikeInteractor(), actions: actions)
    }
    
    //MARK: - Recipe Details
    func makeRecipeDetailsViewController(id: String) -> UIViewController {
        return RecipeDetailsViewController.create(with: makeRecipeDetailsViewModel(id: id), dishImagesRepository: makeDishImagesRepository())
    }
    
    func makeRecipeDetailsViewModel(id: String) -> RecipeDetailsViewModel {
        return DefaultRecipeDetailsViewModel(id: id, recepiesRepository: makeRecepiesRepository())
    }
    
    //MARK: - Main TabBar
    func makeMainTabBarViewController(views: [UIViewController]) -> MainTabBarController {
        return MainTabBarController.create(viewModel: makeMainTabBarViewModel(), views: views)
    }
    func makeMainTabBarViewModel() ->  MainTabBarViewModel {
        return MainTabBarViewModel()
    }
    
    // MARK: - Flow Coordinators
    func makeRecepiesSearchFlowCoordinator(navigationController: UINavigationController) -> RecipesSearchFlowCoordinator {
        return RecipesSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func makeMainTabBarFlowCoordinator(window: UIWindow, recepiesSceneDIContainer: RecipesSceneDIContainer) -> MainTabBarFlowCoordinator {
        return MainTabBarFlowCoordinator(window: window,
                                         dependencies: self, recepiesSceneDIContainer: recepiesSceneDIContainer)
    }
    
    func makeFavouriteRecipesFlowCoordinator(navigationController: UINavigationController) -> FavouriteRecipesListFlowCoordinator {
        return FavouriteRecipesListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension RecipesSceneDIContainer: RecipesSearchFlowCoordinatorDependencies {}
extension RecipesSceneDIContainer: MainTabBarFlowCoordinatorDependencies {}
extension RecipesSceneDIContainer: FavouriteRecipesListFlowCoordinatorDependencies {}
