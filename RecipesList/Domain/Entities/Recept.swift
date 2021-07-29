//
//  Recept.swift
//  RecipesList
//
//  Created by Андрей Калямин on 20.07.2021.
//

import Foundation

import Foundation

struct Recept: Equatable, Identifiable {
    typealias Identifier = String
    let id: Identifier
    let title: String?
    let image: String?
}

struct RecepiesPage: Equatable {
    let page: Int
    let totalPages: Int
    let recepies: [Recept]
}
