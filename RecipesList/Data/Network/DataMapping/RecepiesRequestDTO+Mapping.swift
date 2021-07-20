//
//  RecepiesRequestDTO+Mapping.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct RecepiesRequestDTO: Encodable {
    let query: String
    let page: Int
}
