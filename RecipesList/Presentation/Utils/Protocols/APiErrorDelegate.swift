//
//  APiErrorDelegate.swift
//  RecipesList
//
//  Created by Андрей Калямин on 21.09.2021.
//

import Foundation

protocol ApiErrorDelegate: class {
    var error: Observable<String> { get }
    func update()
}
