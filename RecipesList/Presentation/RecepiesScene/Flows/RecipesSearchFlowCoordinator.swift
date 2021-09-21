//
//  RecepiesSearchFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

protocol RecipesSearchFlowCoordinatorDependencies  {
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
    func makeRecipeDetailsViewController(id: String, errorAction: (ApiErrorDelegate) -> Void) -> UIViewController
    func makeApiErrorViewController(delegate: ApiErrorDelegate) -> ApiErrorViewController
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
        
        let vc = dependencies.makeRecepiesListViewController(actions: RecepiesListViewModelActions(showRecipeDetails: showRecipeDetails, showApiError: showApiError))
        navigationController?.pushViewController(vc, animated: false)
        recepiesListVC = vc
    }
    
    private func showRecipeDetails(id: String) {
        let vc = dependencies.makeRecipeDetailsViewController(id: id, errorAction: showApiError)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showApiError(delegate: ApiErrorDelegate) {
        let vc = dependencies.makeApiErrorViewController(delegate: delegate)
        navigationController?.present(vc, animated: true)
    }
}
