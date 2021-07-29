//
//  RecipeDetailsHeaderViewCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 27.07.2021.
//

import Foundation
import UIKit

class RecipeDetailsHeaderViewCell: UICollectionViewCell {
    
    private var imageSource: String?
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    func fill(with imageSource: String, dishImageRepository: DishImagesRepository?) {
        self.imageSource = imageSource
        self.imageRepository = dishImageRepository
        updateDishImage()
    }
    
    func setupImage(imagePic: UIImage) {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.image = imagePic
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
    }
    
    private func updateDishImage() {
        
        guard var imagePath = self.imageSource else { return }
        imagePath = imagePath.replacingOccurrences(of: " ", with: "-")
        
        imageLoadTask = imageRepository?.fetchDetailImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.setupImage(imagePic: UIImage(data: data)!)
            }
            self.imageLoadTask = nil
        }
        
    }
}
