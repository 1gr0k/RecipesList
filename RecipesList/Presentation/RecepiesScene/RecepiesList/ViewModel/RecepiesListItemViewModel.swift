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
}

extension RecepiesListItemViewModel {
    
    init(recept: Recept) {
        self.title = recept.title ?? ""
        self.image = recept.id
        self.id = recept.id ?? ""
        
    }
}
