//
//  RecipeDetailsViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import Foundation

protocol RecipeDetailsViewModelInput {
    func viewDidLoad()
}

protocol RecipeDetailsViewModelOutput {
    var id: String { get }
    var recipe: Observable<RecipeDetailsCellViewModel?> { get }
    
}

protocol RecipeDetailsViewModel: RecipeDetailsViewModelInput, RecipeDetailsViewModelOutput {  }

final class DefaultRecipeDetailsViewModel: RecipeDetailsViewModel {
    
    private let recepiesRepository: RecepiesRepository
    private var detailLoadTask: Cancellable? { willSet { detailLoadTask?.cancel() } }
    
    let id: String
    var recipe: Observable<RecipeDetailsCellViewModel?> = Observable(nil)
    
    func viewDidLoad() {
        getDetails()
    }

    init(recipe: Recipe, recepiesRepository: RecepiesRepository) {
        self.id = recipe.id
        self.recepiesRepository = recepiesRepository
    }
    
    private func getDetails() {
   
        detailLoadTask = recepiesRepository.fetchRecipeDetails(query: DetailRecipeQuery(query: id)) { result  in
            switch result {
            case .success(let data):
                print(data)
                self.recipe.value = RecipeDetailsCellViewModel(recipe: data)
            case .failure: break
            }
        }
        
    }
}
