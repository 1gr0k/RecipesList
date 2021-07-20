//
//  RecepiesSceneDIContainer.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit
import SwiftUI

final class RecepiesSceneDIContainer {
    
    struct Dependencies{
        let apiDataTransferService: DataTransferService
//        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    //MARK: - Persistent Storage
    lazy var recepiesQueriesStorage: RecepiesQueriesStorage = CoreDataRecepiesQueriesStorage(maxStorageLimit: 10)
    lazy var recepiesResponseCache: RecepiesResponseStorage = CoreDataRecepiesResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Use Cases
    func makeSearchRecepiesUseCase() -> SearchRecepiesUseCase {
        return DefaultSearchRecepiesUseCase(recepiesRepository: makeRecepiesRepository(), recepiesQueriesRepository: makeRecepiesQueriesRepository())
    }
    
    //MARK: - Repositories
    func makeRecepiesRepository() -> RecepiesRepository {
        return DefaultRecepiesRepository(dataTransferService: dependencies.apiDataTransferService, cache: recepiesResponseCache)
    }
    
    func makeRecepiesQueriesRepository() -> RecepiesQueriesRepository {
        return DefaultRecepiesQueriesRepository(dataTransferService: dependencies.apiDataTransferService, recepiesQueriesPersistentStorage: recepiesQueriesStorage)
    }
    
    
    //MARK: - Movies List
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController {
        return RecepiesListViewController.create(with: makeRecepiesListViewModel(actions: actions))
    }
    
    func makeRecepiesListViewModel(actions: RecepiesListViewModelActions) -> RecepiesListViewModel {
        return DefaultRecepiesListViewModel(searchReceptUseCase: makeSearchRecepiesUseCase(), actions: actions)
    }
    
    //MARK: - Movies Queries Suggestions List
    
//    func makeRecepiesQueriesSuggestionsListViewController(didSelect: @escaping RecepiesQueryListViewModelDidSelectAction) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = MoviesQueryListView(viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect))
//            return UIHostingController(rootView: view)
//        } else { // UIKit
//            return MoviesQueriesTableViewController.create(with: makeMoviesQueryListViewModel(didSelect: didSelect))
//        }
//    }
//    
//    func makeRecepiesQueryListViewModel(didSelect: @escaping RecepiesQueryListViewModelDidSelectAction) -> RecepiesQueryListViewModel {
//        return DefaultRecepiesQueryListViewModel(numberOfQueriesToShow: 10,
//                                               fetchRecentReceptQueriesUseCaseFactory: makeFetchRecentReceptQueriesUseCase,
//                                               didSelect: didSelect)
//    }
//
//    @available(iOS 13.0, *)
//    func makeRecepiesQueryListViewModelWrapper(didSelect: @escaping RecepiesQueryListViewModelDidSelectAction) -> RecepiesQueryListViewModelWrapper {
//        return MRecepiesQueryListViewModelWrapper(viewModel: makeRecepiesQueryListViewModel(didSelect: didSelect))
//    }
    
    // MARK: - Flow Coordinators
    func makeRecepiesSearchFlowCoordinator(navigationController: UINavigationController) -> RecepiesSearchFlowCoordinator {
        return RecepiesSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension RecepiesSceneDIContainer: RecepiesSearchFlowCoordinatorDependencies {}
