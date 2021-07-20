//
//  RecepiesListItemViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import Foundation

struct RecepiesListItemViewModel: Equatable {
    let title: String
}

extension RecepiesListItemViewModel {
    
    init(recept: Recept) {
        self.title = recept.title ?? ""
    }
}
