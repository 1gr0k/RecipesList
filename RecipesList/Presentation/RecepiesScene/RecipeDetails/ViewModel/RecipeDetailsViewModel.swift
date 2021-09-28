//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import Foundation
import InjectPropertyWrapper

enum SectionType: Int, CaseIterable {
    case header
    case dishTypes
    case ingredientsModels
}

protocol RecipeDetailsViewModelInput {
    func viewDidLoad()
    func createApiErrorController() -> ApiErrorViewController
    func setupId(id: String)
}

protocol RecipeDetailsViewModelOutput {
    var id: String? { get set }
    var imagePath: String? { get set }
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> { get }
    var error: Observable<String> { get }
}

protocol RecipeDetailsViewModel: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {  }

final class DefaultRecipeDetailsViewModel: RecipeDetailsViewModel, ApiErrorDelegate {
    
    @Inject private var recepiesRepository: RecepiesRepository
    private var detailLoadTask: Cancellable? { willSet { detailLoadTask?.cancel() } }
    @Inject private var dependencies: RecipesSceneDIContainer
    
    var id: String? = "661640"
    var imagePath: String? = "Stilton-Balsamic-Pizza"
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> = Observable(nil)
    let error: Observable<String> = Observable("")
    
    func viewDidLoad() {
        getDetails()
    }

    func setupId(id: String) {
        self.id = id
        self.imagePath = id.replacingOccurrences(of: " ", with: "-")
    }
    
    private func getDetails() {
   
        detailLoadTask = recepiesRepository.fetchRecipeDetails(query: DetailRecipeQuery(query: id!)) { result  in
            switch result {
            case .success(let data):
                var tempArray = [SectionType: [RecipeDetailCellViewModel]]()
                let headerModel = HeaderRecipeDeatilsCellViewModel(title: data.title, image: self.imagePath!)
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
        let delegate: ApiErrorDelegate = self
        let vc = AppDelegate.container.resolve(ApiErrorViewController.self, argument: delegate)!
        return vc
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
