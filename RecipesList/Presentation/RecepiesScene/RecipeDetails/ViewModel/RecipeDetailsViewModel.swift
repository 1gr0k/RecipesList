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
}

protocol RecipeDetailsViewModelOutput {
    var id: String { get }
    var imagePath: String { get }
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> { get }
    
}

protocol RecipeDetailsViewModel: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {  }

final class DefaultRecipeDetailsViewModel: RecipeDetailsViewModel {
    
    private let recepiesRepository: RecepiesRepository
    private var detailLoadTask: Cancellable? { willSet { detailLoadTask?.cancel() } }
    
    let id: String
    let imagePath: String
    var dataSource : Observable<[SectionType: [RecipeDetailCellViewModel]]?> = Observable(nil)
    
    func viewDidLoad() {
        getDetails()
    }

    init(id: String, recepiesRepository: RecepiesRepository) {
        self.id = id
        self.recepiesRepository = recepiesRepository
        self.imagePath = id.replacingOccurrences(of: " ", with: "-")
    }
    
    private func getDetails() {
   
        detailLoadTask = recepiesRepository.fetchRecipeDetails(query: DetailRecipeQuery(query: id)) { result  in
            switch result {
            case .success(let data):
                var tempArray = [SectionType: [RecipeDetailCellViewModel]]()
                let headerModel = HeaderRecipeDeatilsCellViewModel(title: data.title, image: self.imagePath, readyInMinutes: data.readyInMinutes)
                let dishTypesModel = DishTypesRecipeDetailsCellViewModel(dishTypes: data.dishTypes)
                let ingredientsModels = data.extendedIngredients.map( {ExtendedIngredientsRecipeDetailsCellViewModel(id: $0.id, name: $0.name)} )
                tempArray[.header] = [headerModel]
                tempArray[.dishTypes] = [dishTypesModel]
                tempArray[.ingredientsModels] = ingredientsModels
                self.dataSource.value = tempArray
            case .failure: break
            }
        }
        
    }
}
