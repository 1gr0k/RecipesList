//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import Foundation

enum SectionType: Int, CaseIterable {
    case header
    case dishTypes
    case ingredientsModels
}

protocol RecipeDetailsViewModelInput {
    func viewDidLoad()
    func createApiErrorController() -> ApiErrorViewController
}

protocol RecipeDetailsViewModelOutput {
    var id: String { get }
    var imagePath: String { get }
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> { get }
    var error: Observable<String> { get }
}

protocol RecipeDetailsViewModel: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {  }

final class DefaultRecipeDetailsViewModel: RecipeDetailsViewModel, ApiErrorDelegate {
    
    private let recepiesRepository: RecepiesRepository
    private var detailLoadTask: Cancellable? { willSet { detailLoadTask?.cancel() } }
    private let dependencies: RecipesSearchFlowCoordinatorDependencies
    
    let id: String
    let imagePath: String
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> = Observable(nil)
    let error: Observable<String> = Observable("")
    
    func viewDidLoad() {
        getDetails()
    }

    init(id: String, recepiesRepository: RecepiesRepository, dependencies: RecipesSearchFlowCoordinatorDependencies) {
        self.id = id
        self.recepiesRepository = recepiesRepository
        self.imagePath = id.replacingOccurrences(of: " ", with: "-")
        self.dependencies = dependencies
    }
    
    private func getDetails() {
   
        detailLoadTask = recepiesRepository.fetchRecipeDetails(query: DetailRecipeQuery(query: id)) { result  in
            switch result {
            case .success(let data):
                var tempArray = [SectionType: [RecipeDetailCellViewModel]]()
                let headerModel = HeaderRecipeDeatilsCellViewModel(title: data.title, image: self.imagePath)
                let dishTypesModel = DishTypesRecipeDetailsCellViewModel(dishTypes: data.dishTypes)
                let ingredientsModels = data.extendedIngredients.map( {ExtendedIngredientsRecipeDetailsCellViewModel(id: $0.id, name: $0.name)} )
                tempArray[.header] = [headerModel]
                tempArray[.dishTypes] = [dishTypesModel]
                tempArray[.ingredientsModels] = ingredientsModels
                self.dataSource.value = tempArray
            case .failure(let error):
                if error.isApiKeyError { self.error.value = "Некорректный ключ API" }
                if error.isApiKeyAvaliableRequests { self.error.value = "Достигнут дневной лимит запросов ключа" }
                if error.isInternetConnectionError { self.error.value = "Отсутствует интернет соединение"}
            }
        }
    }
    
    func createApiErrorController() -> ApiErrorViewController {
        return dependencies.makeApiErrorViewController(delegate: self)
    }
    
    func update() {
        self.getDetails()
    }
}
