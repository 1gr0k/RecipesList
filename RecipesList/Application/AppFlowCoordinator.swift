//
//  AppFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let recepiesSceneDIContainer = appDIContainer.makeRecepiesSceneDIContainer()
        let flow = recepiesSceneDIContainer.makeRecepiesSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
