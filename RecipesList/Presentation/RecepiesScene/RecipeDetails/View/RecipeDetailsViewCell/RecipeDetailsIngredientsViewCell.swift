//
//  RecipeDetailsCellViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 26.07.2021.
//

import UIKit

class RecipeDetailsIngredientsViewCell: UICollectionViewCell {
    
    private var viewModel: RecipesList.ExtendedIngredient!
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private var imagePic: UIImage?
    private var stackLink: UIStackView?
    
    
//    override func updateConfiguration(using state: UICellConfigurationState) {
//        super.updateConfiguration(using: state)
//        stackLink?.removeFromSuperview()
//    }
    
    override func prepareForReuse() {
        stackLink?.removeFromSuperview()
    }
    
    func fill(with viewModel: RecipesList.ExtendedIngredient, dishImageRepository: DishImagesRepository?) {
        
        self.viewModel = viewModel
        self.imageRepository = dishImageRepository
        updateDishImage()
    }
    
    private func setupStack(imagePic: UIImage) {
        
        let stack = UIStackView()
        stackLink = stack
        let image = UIImageView()
        let label = UILabel()
        
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(label)
        self.addSubview(stack)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.image = imagePic
        image.widthAnchor.constraint(equalToConstant: self.frame.width * 0.8).isActive = true
        image.heightAnchor.constraint(equalToConstant: self.frame.height * 0.8).isActive = true
        
        label.text = viewModel.name
        
        stack.axis  = NSLayoutConstraint.Axis.vertical
        stack.alignment = UIStackView.Alignment.center
        stack.distribution = UIStackView.Distribution.fillProportionally
        stack.spacing   = 8.0
    
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    private func updateDishImage() {
        let imagePath = viewModel.name.replacingOccurrences(of: " ", with: "-")
        imageLoadTask = imageRepository?.fetchIngredientImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.setupStack(imagePic: UIImage(data: data)!)
            }
            self.imageLoadTask = nil
        }
    }
}
