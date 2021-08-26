//
//  RecepiesListItemViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import Foundation

struct RecepiesListItemViewModel: Equatable {
    let id: String?
    let title: String
    let image: String?
    var favourite: Bool?
}

extension RecepiesListItemViewModel {
    
    init(recept: Recipe) {
        self.title = recept.title ?? ""
        self.image = recept.id
        self.id = recept.id
        self.favourite = recept.favourite
    }
}
