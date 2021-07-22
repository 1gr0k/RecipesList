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
        let imageDataTransferService: DataTransferService
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
    
    func makeDishImagesRepository() -> DishImagesRepository {
        return DefaultDishImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    
    //MARK: - Movies List
    func makeRecepiesListViewController(actions: RecepiesListViewModelActions) -> RecepiesListViewController {
        return RecepiesListViewController.create(with: makeRecepiesListViewModel(actions: actions), dishImagesRepository: makeDishImagesRepository())
    }
    
    func makeRecepiesListViewModel(actions: RecepiesListViewModelActions) -> RecepiesListViewModel {
        return DefaultRecepiesListViewModel(searchReceptUseCase: makeSearchRecepiesUseCase(), actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeRecepiesSearchFlowCoordinator(navigationController: UINavigationController) -> RecepiesSearchFlowCoordinator {
        return RecepiesSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension RecepiesSceneDIContainer: RecepiesSearchFlowCoordinatorDependencies {}
