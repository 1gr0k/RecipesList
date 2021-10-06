//
//  AppFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit
import InjectPropertyWrapper
import SwinjectStoryboard

final class AppFlowCoordinator {

    var navigationController: UINavigationController?
    private var window: UIWindow?
    private var mainFlow: MainTabBarFlowCoordinator?
    
    init() {}


    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let flow = AppDelegate.container.resolve(MainTabBarFlowCoordinator.self, argument: window!)!
        mainFlow = flow
        mainFlow!.start()
    }
    
    func openDetail(id: String) {
        let storyboard = SwinjectStoryboard.create(name: "RecipeDetailsViewController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController()! as! RecipeDetailsViewController
        vc.setupId(id: id)
        mainFlow!.mainListNavigationController.pushViewController(vc, animated: true)
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
