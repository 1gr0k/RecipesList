//
//  AppFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController?
    private var window: UIWindow?
    private var recepiesDIContainer: RecipesSceneDIContainer?
    private let appDIContainer: AppDIContainer
    
    init(recepiesDIContainer: RecipesSceneDIContainer,
             appDIContainer: AppDIContainer) {
            self.recepiesDIContainer = recepiesDIContainer
            self.appDIContainer = appDIContainer
        }


    init(window: UIWindow,
         appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    func start() {
        let recepiesSceneDIContainer = appDIContainer.makeRecepiesSceneDIContainer()
        let flow = recepiesSceneDIContainer.makeMainTabBarFlowCoordinator(window: window!, recepiesSceneDIContainer: recepiesSceneDIContainer)
        flow.start()
    }

    func startRecipesList(navigationController: UINavigationController) {
        let flow = recepiesDIContainer!.makeRecepiesSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    func startFavouriteList(navigationController: UINavigationController) {
        let flow = recepiesDIContainer!.makeFavouriteRecipesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
