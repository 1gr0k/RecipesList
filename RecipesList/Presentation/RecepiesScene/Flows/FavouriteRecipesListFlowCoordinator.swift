//
//  FavouriteRecipesListFlowCoordinator.swift
//  FavouriteRecipesListFlowCoordinator
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit

protocol FavouriteRecipesListFlowCoordinatorDependencies  {
//    func makeFavouriteRecipesViewController() -> FavouriteRecipesTableViewController
    func makeFavouriteRecipesViewController() -> UIViewController
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
        let vc = dependencies.makeFavouriteRecipesViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}
