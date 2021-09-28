//
//  RecepiesSceneDIContainer.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit
import SwiftUI

final class RecipesSceneDIContainer {
    
    // MARK: - Flow Coordinators
    func makeRecepiesSearchFlowCoordinator(navigationController: UINavigationController) -> RecipesSearchFlowCoordinator {
        return RecipesSearchFlowCoordinator(navigationController: navigationController)
    }
    
    func makeMainTabBarFlowCoordinator(window: UIWindow, recepiesSceneDIContainer: RecipesSceneDIContainer) -> MainTabBarFlowCoordinator {
        return MainTabBarFlowCoordinator(window: window)
    }
    
    func makeFavouriteRecipesFlowCoordinator(navigationController: UINavigationController) -> FavouriteRecipesListFlowCoordinator {
        return FavouriteRecipesListFlowCoordinator(navigationController: navigationController)
    }
}

