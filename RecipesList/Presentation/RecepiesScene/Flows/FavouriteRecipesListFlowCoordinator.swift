//
//  FavouriteRecipesListFlowCoordinator.swift
//  FavouriteRecipesListFlowCoordinator
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit
import SwinjectStoryboard

protocol FavouriteRecipesListFlowCoordinatorDependencies  {
    func makeFavouriteRecipesViewController(actions: RecepiesListViewModelActions) -> UIViewController
    func makeApiErrorViewController(delegate: ApiErrorDelegate) -> ApiErrorViewController
}

final class FavouriteRecipesListFlowCoordinator {
    
    private weak var navigationController: UINavigationController?

    private weak var recepiesListVC: RecepiesListViewController?
    private weak var recepiesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = SwinjectStoryboard.create(name: "FavouriteRecipesTableViewController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController() as! FavouriteRecipesTableViewController
        vc.setupActions(actions: RecepiesListViewModelActions(showRecipeDetails: showRecipeDetails, showApiError: showApiError))
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showRecipeDetails(id: String) {
        let storyboard = SwinjectStoryboard.create(name: "RecipeDetailsViewController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController()! as! RecipeDetailsViewController
        vc.setupId(id: id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showApiError(delegate: ApiErrorDelegate) {
        let vc = AppDelegate.container.resolve(ApiErrorViewController.self, argument: delegate)!
        navigationController?.present(vc, animated: true)
    }
}
