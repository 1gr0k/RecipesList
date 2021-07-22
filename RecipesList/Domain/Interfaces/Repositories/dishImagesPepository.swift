//
//  ImagePepository.swift
//  RecipesList
//
//  Created by Андрей Калямин on 21.07.2021.
//

import Foundation

protocol DishImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
