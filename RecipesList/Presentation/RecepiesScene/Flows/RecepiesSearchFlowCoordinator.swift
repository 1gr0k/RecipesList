//
//  RecepiesSearchFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

protocol RecepiesSearchFlowCoordinatorDependencies  {
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
}

final class RecepiesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: RecepiesSearchFlowCoordinatorDependencies

    private weak var recepiesListVC: RecepiesListViewController?
    private weak var recepiesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: RecepiesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        let vc = dependencies.makeRecepiesListViewController(actions: RecepiesListViewModelActions(showReceptDetails: { test in
            print("test")
        }))
        navigationController?.pushViewController(vc, animated: false)
        recepiesListVC = vc
    }
}
