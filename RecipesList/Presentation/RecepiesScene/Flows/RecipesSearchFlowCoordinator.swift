//
//  RecepiesSearchFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

protocol RecipesSearchFlowCoordinatorDependencies  {
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
    func makeRecipeDetailsViewController(recipe: Recipe) -> UIViewController
}

final class RecipesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: RecipesSearchFlowCoordinatorDependencies

    private weak var recepiesListVC: RecepiesListViewController?
    private weak var recepiesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: RecipesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        let vc = dependencies.makeRecepiesListViewController(actions: RecepiesListViewModelActions(showRecipeDetails: showRecipeDetails))
        navigationController?.pushViewController(vc, animated: false)
        recepiesListVC = vc
    }
    
    private func showRecipeDetails(recipe: Recipe) {
        let vc = dependencies.makeRecipeDetailsViewController(recipe: recipe)
        navigationController?.pushViewController(vc, animated: true)
    }
}
