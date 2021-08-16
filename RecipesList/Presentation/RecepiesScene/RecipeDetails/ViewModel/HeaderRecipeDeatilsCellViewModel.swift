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
    
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}
