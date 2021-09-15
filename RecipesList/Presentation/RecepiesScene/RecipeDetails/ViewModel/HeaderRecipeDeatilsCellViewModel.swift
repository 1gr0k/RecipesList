//
//  HeaderRecipeDeatilsViewModel.swift
//  HeaderRecipeDeatilsViewModel
//
//  Created by Андрей Калямин on 13.08.2021.
//

import Foundation

class HeaderRecipeDeatilsCellViewModel: RecipeDetailCellViewModel {
    let title: String
    let image: String
    let readyInMinutes: Int
    
    init(title: String, image: String, readyInMinutes: Int) {
        self.title = title
        self.image = image
        self.readyInMinutes = (min(readyInMinutes, 120))
    }
}
