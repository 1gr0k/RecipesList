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
    
    init(navigationController: UINavigationController,
             appDIContainer: AppDIContainer) {
            self.navigationController = navigationController
            self.appDIContainer = appDIContainer
        }


    init(window: UIWindow,
         appDIContainer: AppDIContainer) {
        self.window = window
        self.appDIContainer = appDIContainer
    }


    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let recepiesSceneDIContainer = appDIContainer.makeRecepiesSceneDIContainer()
        let flow = recepiesSceneDIContainer.makeMainTabBarFlowCoordinator(window: window!, recepiesSceneDIContainer: recepiesSceneDIContainer)
        flow.start()
    }

    func startRecipesList(recepiesSceneDIContainer: RecipesSceneDIContainer) {
        let flow = recepiesSceneDIContainer.makeRecepiesSearchFlowCoordinator(navigationController: navigationController!)
        flow.start()
    }
}
