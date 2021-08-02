//
//  AppDIContainer.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["apiKey": appConfiguration.apiKey,
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imagesBaseURL)!)
        let imagesDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeRecepiesSceneDIContainer() -> RecipesSceneDIContainer {
        let dependencies = RecipesSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, imageDataTransferService: imageDataTransferService)
        return RecipesSceneDIContainer(dependencies: dependencies)
    }
}
