//
//  RecepiesListItemCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import UIKit

final class RecepiesListItemCell: UITableViewCell {
    
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    
    static let reuseIdentifier = String(describing: RecepiesListItemCell.self)
    static let height = CGFloat(300)
    
    private var viewModel: RecepiesListItemViewModel!
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    func fill(with viewModel: RecepiesListItemViewModel, dishImageRepository: DishImagesRepository?) {
        self.viewModel = viewModel
        self.imageRepository = dishImageRepository
        favouriteImage.image = viewModel.favourite! ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        idLabel.text = viewModel.title
        updateDishImage()
    }
    
    private func updateDishImage() {
        dishImageView.image = nil
        guard let imagePath = viewModel.id else { return }
        
        imageLoadTask = imageRepository?.fetchImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.image == imagePath else { return }
            if case let .success(data) = result {
                self.dishImageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
        
    }
}
