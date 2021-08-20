//
//  MainTabBarFlowCoorfinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.07.2021.
//

import UIKit

protocol MainTabBarFlowCoordinatorDependencies  {
    func makeMainTabBarViewController(views: [UIViewController]) -> MainTabBarController
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
}

final class MainTabBarFlowCoordinator {

    private weak var window: UIWindow?
    private let dependencies: MainTabBarFlowCoordinatorDependencies
    private let recepiesSceneDIContainer: RecipesSceneDIContainer
    
    init(window: UIWindow,
         dependencies: MainTabBarFlowCoordinatorDependencies,
         recepiesSceneDIContainer: RecipesSceneDIContainer) {
        self.window = window
        self.dependencies = dependencies
        self.recepiesSceneDIContainer = recepiesSceneDIContainer
    }
    
    func start() {
        
        let mainListNavigationController = UINavigationController()
        let favouriteListNavigationController = UINavigationController()
        
        let appDIContainer = AppDIContainer()
        let appFlowCoordinator = AppFlowCoordinator(recepiesDIContainer: recepiesSceneDIContainer, appDIContainer: appDIContainer)
        
        appFlowCoordinator.startRecipesList(navigationController: mainListNavigationController)
        appFlowCoordinator.startFavouriteList(navigationController: favouriteListNavigationController)
        
        window?.rootViewController = dependencies.makeMainTabBarViewController(views: [mainListNavigationController, favouriteListNavigationController])
    }
}
