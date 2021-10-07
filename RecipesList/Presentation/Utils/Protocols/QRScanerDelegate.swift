//
//  QRScanerDelegate.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.09.2021.
//

import Foundation

protocol QRScanerDelegate: class {
    func showDetailRecipe(id: String)
}
