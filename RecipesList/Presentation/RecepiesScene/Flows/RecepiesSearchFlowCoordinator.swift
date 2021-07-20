//
//  RecepiesSearchFlowCoordinator.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import UIKit

protocol RecepiesSearchFlowCoordinatorDependencies  {
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController
//    func makeRecepiesDetailsViewController(Recept: Recept) -> UIViewController
//    func makeRecepiesQueriesSuggestionsListViewController(didSelect: @escaping RecepiesQueryListViewModelDidSelectAction) -> UIViewController
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
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        //let actions = RecepiesListViewModelActions(showReceptDetails: showReceptDetails)
        
        let vc = dependencies.makeRecepiesListViewController(actions: RecepiesListViewModelActions(showReceptDetails: { test in
            print("test")
        }))
        navigationController?.pushViewController(vc, animated: false)
        recepiesListVC = vc
    }

//    private func showReceptDetails(Recept: Recept) {
//        let vc = dependencies.makeRecepiesDetailsViewController(Recept: Recept)
//        navigationController?.pushViewController(vc, animated: true)
//    }

//    private func showReceptQueriesSuggestions(didSelect: @escaping (ReceptQuery) -> Void) {
//        guard let recepiesListViewController = recepiesListVC, recepiesQueriesSuggestionsVC == nil,
//            let container = recepiesListViewController.suggestionsListContainer else { return }
//
//        let vc = dependencies.makeRecepiesQueriesSuggestionsListViewController(didSelect: didSelect)
//
//        RecepiesListViewController.add(child: vc, container: container)
//        RecepiesQueriesSuggestionsVC = vc
//        container.isHidden = false
//    }
//
//    private func closeReceptQueriesSuggestions() {
//        RecepiesQueriesSuggestionsVC?.remove()
//        RecepiesQueriesSuggestionsVC = nil
//        RecepiesListVC?.suggestionsListContainer.isHidden = true
//    }
}
