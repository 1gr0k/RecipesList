//
//  Recept.swift
//  RecipesList
//
//  Created by Андрей Калямин on 20.07.2021.
//

import Foundation

struct Recipe: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let title: String?
    let image: String?
    let favourite: Bool?
}

struct RecepiesPage: Equatable {
    let page: Int
    let totalPages: Int
    let recepies: [Recipe]
}
