//
//  FavouriteRecipesListFlowCoordinator.swift
//  FavouriteRecipesListFlowCoordinator
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit

protocol FavouriteRecipesListFlowCoordinatorDependencies  {
    func makeFavouriteRecipesViewController(actions: RecepiesListViewModelActions) -> UIViewController
    func makeRecipeDetailsViewController(id: String) -> UIViewController
}

final class FavouriteRecipesListFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: FavouriteRecipesListFlowCoordinatorDependencies

    private weak var recepiesListVC: RecepiesListViewController?
    private weak var recepiesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: FavouriteRecipesListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeFavouriteRecipesViewController(actions: RecepiesListViewModelActions(showRecipeDetails: showRecipeDetails))
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showRecipeDetails(id: String) {
        let vc = dependencies.makeRecipeDetailsViewController(id: id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
