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
    
    init() {}


    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let flow = AppDelegate.container.resolve(MainTabBarFlowCoordinator.self, argument: window!)!
        flow.start()
    }

    func startRecipesList(navigationController: UINavigationController) {
        let flow = AppDelegate.container.resolve(RecipesSearchFlowCoordinator.self, argument: navigationController)!
        flow.start()
    }
    
    func startFavouriteList(navigationController: UINavigationController) {
        let flow = AppDelegate.container.resolve(FavouriteRecipesListFlowCoordinator.self, argument: navigationController)!
        flow.start()
    }
}
