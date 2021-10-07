//
//  SWinjectContainer.swift
//  RecipesList
//
//  Created by Андрей Калямин on 24.09.2021.
//

import Foundation
import Swinject
import SwinjectStoryboard
import InjectPropertyWrapper
import SwiftUI

extension Container: InjectPropertyWrapper.Resolver {
    
    func registerAllInjections() {
        registerStorages()
        registerInteractors()
        registerTransferService()
        registerConfigurations()
        registerRepositories()
        registerUseCases()
        registerWindow()
        registerFlowCoordinators()
        
        registerRecipeDetais()
        registerRecipesList()
        registerFavouriteRecipesList()
        registerApiError()
        registerTabBar()
        
    }
    
    func registerInteractors() {
        
        self.register(SetApiKeyInteractor.self) { _ in
            SetApiKeyInteractor()
        }
        
        self.register(RemoveLikeInteractor.self) { resolver in
            return RemoveLikeInteractor()
        }
        
        self.register(SetLikeInteractor.self) { _ in
            SetLikeInteractor()
        }
        
        self.register(GetAllLikesInteractor.self) { _ in
            GetAllLikesInteractor()
        }
        
    }
    
    func registerStorages() {
        self.register(RecepiesQueriesStorage.self) { _ in
            CoreDataRecepiesQueriesStorage(maxStorageLimit: 10)
        }
        
        self.register(RecipesResponseStorage.self) { _ in
            CoreDataRecepiesResponseStorage()
        }
        
        self.register(FavouriteRecipesStorage.self) { _ in
            CoreDataFavouriteRecipesStorage()
        }
    }
    
    func registerRepositories() {
        self.register(RecepiesRepository.self) { _ in
            DefaultRecepiesRepository()        }
        
        self.register(RecepiesQueriesRepository.self) { _ in
            DefaultRecepiesQueriesRepository()
        }
    }
    
    func registerTransferService() {
        self.register(DataTransferService.self, name: "apiDataTransferService") { resolver in
            @Inject var appConfig: AppConfiguration
            let config = ApiDataNetworkConfig(baseURL: URL(string: appConfig.apiBaseURL)!,
                                              queryParameters: ["apiKey": appConfig.apiKey])

            let apiDataNetwork = DefaultNetworkService(config: config)
            return DefaultDataTransferService(with: apiDataNetwork)
        }
        
        self.register(DataTransferService.self, name: "imageDataTransferService") { resolver in
            @Inject var appConfig: AppConfiguration
            let config = ApiDataNetworkConfig(baseURL: URL(string: appConfig.imagesBaseURL)!)
            let imagesDataNetwork = DefaultNetworkService(config: config)
            return DefaultDataTransferService(with: imagesDataNetwork)
        }
    }
    
    func registerConfigurations() {
        self.register(AppConfiguration.self) { _ in
            AppConfiguration()
        }
    }
    
    func registerUseCases() {
        self.register(SearchRecepiesUseCase.self) { _ in
            DefaultSearchRecepiesUseCase()
        }
        
        self.register(RecipesListWithFavouritesUseCase.self) { _ in
            DefaultFavoritesRecipesUseCase()
        }
        
        self.register(FavouriteRecipesListUseCase.self) { _ in
            DefaultFavouriteRecipesListUseCase()
        }
    }
    
    func registerWindow() {
        self.register(UIWindow.self, name: "mainWindow") { _ in
            UIWindow(frame: UIScreen.main.bounds)
        }
    }
    
    func registerRecipeDetais() {
        self.storyboardInitCompleted(UIViewController.self, name: "recipeDetailsViewController") { r, c in
            RecipeDetailsViewController.create()
        }
        
        self.register(RecipeDetailsViewModel.self) { _ in
            DefaultRecipeDetailsViewModel()
        }
    }
    
    func registerRecipesList() {
        self.storyboardInitCompleted(UIViewController.self, name: "recepiesListViewController") { r, c in
            RecepiesListViewController.create()
        }
        
        self.register(RecepiesListViewModel.self) { _ in
            DefaultRecipesListViewModel()
        }
    }
    
    func registerFavouriteRecipesList() {
        self.storyboardInitCompleted(UIViewController.self, name: "favouriteRecipesTableViewController") { r, c in
            FavouriteRecipesTableViewController.create()
        }
        
        self.register(FavouriteRecipesViewModel.self) { _ in
            DefaultFavouriteRecipesViewModel()
        }
    }
    
    func registerApiError() {
        self.register(ApiErrorViewController.self) { _, delegate in
            ApiErrorViewController.create(delegate: delegate)
        }
        
        self.register(ApiErrorViewModel.self) { _ in
            DefaultApiErrorViewModel()
        }
    }
    
    func registerTabBar() {
        self.storyboardInitCompleted(UIViewController.self, name: "mainTabBarController") { r, c in
            MainTabBarController.create()
        }
        
        self.register(MainTabBarViewModel.self) { _ in
            DefaultMainTabBarViewModel()
        }
    }
    
    func registerFlowCoordinators() {
        
        self.register(MainTabBarFlowCoordinator.self) { r, window in
            return MainTabBarFlowCoordinator(window: window)
        }
        
        self.register(RecipesSearchFlowCoordinator.self) { _, navigationController in
            RecipesSearchFlowCoordinator(navigationController: navigationController)
        }
        
        self.register(FavouriteRecipesListFlowCoordinator.self) { _, navigationController in
            FavouriteRecipesListFlowCoordinator(navigationController: navigationController)
        }
        
        
    }
}
