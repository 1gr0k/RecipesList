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
                let error = ErrorType(error: error as! NetworkError)
                self.error.value = error.errorMessage
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

extension DefaultRecipeDetailsViewModel {
    enum ErrorType {
    case apiKey
    case available
    case connectionError
    case defaultError

        var errorMessage: String {
            switch self {
            case .apiKey:
                return "Некорректный ключ API"
            case .available:
                return "Достигнут дневной лимит запросов ключа"
            case .connectionError:
                return "Отсутствует интернет соединение"
            default:
                return "Что-то пошло не так"
            }
        }
        
        init(error: NetworkError) {
            switch error {
            case .unathorized:
                self = .apiKey
            case .requestLimit:
                self = .available
            case .notConnected:
                self = .connectionError
            default:
                self = .defaultError
            }
        }
    }
}
