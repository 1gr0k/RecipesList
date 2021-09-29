//
//  MainTabBarFlowCoorfinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.07.2021.
//

import UIKit
import SwinjectStoryboard
import InjectPropertyWrapper

protocol MainTabBarFlowCoordinatorDependencies  {
    func makeMainTabBarViewController(views: [UINavigationController]) -> MainTabBarController
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
}

final class MainTabBarFlowCoordinator {

    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let mainListNavigationController = UINavigationController()
        let favouriteListNavigationController = UINavigationController()
        
        let appFlowCoordinator = AppFlowCoordinator()
        
        appFlowCoordinator.startRecipesList(navigationController: mainListNavigationController)
        appFlowCoordinator.startFavouriteList(navigationController: favouriteListNavigationController)
        
        let storyboard = SwinjectStoryboard.create(name: "MainTabBarController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController()! as! MainTabBarController
        vc.setupViews(views: [mainListNavigationController, favouriteListNavigationController])
        window?.rootViewController = vc
    }
}
