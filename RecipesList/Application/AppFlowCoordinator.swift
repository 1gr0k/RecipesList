//
//  AppFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit
import InjectPropertyWrapper

final class AppFlowCoordinator {

    var navigationController: UINavigationController?
    private var window: UIWindow?
    @Inject private var appDIContainer: RecipesSceneDIContainer
    
    init() {}


    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let recepiesSceneDIContainer = appDIContainer
        let flow = recepiesSceneDIContainer.makeMainTabBarFlowCoordinator(window: window!, recepiesSceneDIContainer: recepiesSceneDIContainer)
        flow.start()
    }

    func startRecipesList(navigationController: UINavigationController) {
        let flow = appDIContainer.makeRecepiesSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    func startFavouriteList(navigationController: UINavigationController) {
        let flow = appDIContainer.makeFavouriteRecipesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
