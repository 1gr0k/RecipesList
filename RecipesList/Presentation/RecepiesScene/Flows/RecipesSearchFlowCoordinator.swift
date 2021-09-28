//
//  RecepiesSearchFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit
import InjectPropertyWrapper
import SwinjectStoryboard

protocol RecipesSearchFlowCoordinatorDependencies  {
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
//    func makeRecipeDetailsViewController(id: String) -> UIViewController
    func makeApiErrorViewController(delegate: ApiErrorDelegate) -> ApiErrorViewController
}

final class RecipesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?

    private weak var recepiesListVC: RecepiesListViewController?
    private weak var recepiesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let storyboard = SwinjectStoryboard.create(name: "RecepiesListViewController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController() as! RecepiesListViewController
        vc.setupActions(action: RecepiesListViewModelActions(showRecipeDetails: showRecipeDetails, showApiError: showApiError))
        navigationController?.pushViewController(vc, animated: false)
        recepiesListVC = vc
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
