//
//  FavouriteRecipesTableViewCell.swift
//  FavouriteRecipesTableViewCell
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit

class FavouriteRecipesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: FavouriteRecipesTableViewCell.self)
    
    private var viewModel: RecepiesListItemViewModel!
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    private var dishImageView: UIImageView?
    private var stackLink: UIStackView?
    
    override func prepareForReuse() {
        stackLink!.removeFromSuperview()
    }
    
    func fill(with viewModel: RecepiesListItemViewModel, dishImageRepository: DishImagesRepository?) {
        self.viewModel = viewModel
        self.imageRepository = dishImageRepository
        setupViews()
        updateDishImage()
    }
    
    private func updateDishImage() {
        dishImageView!.image = nil
        guard let imagePath = viewModel.id else { return }
        
        imageLoadTask = imageRepository?.fetchImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.id == imagePath else { return }
            if case let .success(data) = result {
                self.dishImageView!.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
        
    }
    
    func setupViews() {
        
        let stacksRatio = 0.2
        let innerStackWidth = (self.frame.width - 32.0) * stacksRatio
        
        let label = UILabel()
        
        let innerStack = UIStackView()
        innerStack.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        let dishImage = UIImageView()
        self.dishImageView = dishImage
        let extStack = UIStackView()
        self.stackLink = extStack
        
        dishImage.translatesAutoresizingMaskIntoConstraints = false
        extStack.translatesAutoresizingMaskIntoConstraints = false
        
        extStack.addSubview(innerStack)
        extStack.addSubview(dishImage)
        
        self.addSubview(extStack)
        
        extStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        extStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        extStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        extStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        extStack.distribution = .fillProportionally
        extStack.axis = .horizontal
        
        innerStack.topAnchor.constraint(equalTo: extStack.topAnchor).isActive = true
        innerStack.bottomAnchor.constraint(equalTo: extStack.bottomAnchor).isActive = true
        innerStack.leadingAnchor.constraint(equalTo: extStack.leadingAnchor).isActive = true
        innerStack.trailingAnchor.constraint(equalTo: extStack.trailingAnchor, constant: -innerStackWidth).isActive = true
        innerStack.alignment = .center
        innerStack.contentMode = .scaleToFill
        
        label.text = viewModel.title
        label.leadingAnchor.constraint(equalTo: innerStack.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: innerStack.trailingAnchor, constant: -8).isActive = true
        label.centerYAnchor.constraint(equalTo: innerStack.centerYAnchor).isActive = true
        label.numberOfLines = 2


        dishImage.trailingAnchor.constraint(equalTo: extStack.trailingAnchor).isActive = true
        dishImage.leadingAnchor.constraint(equalTo: innerStack.trailingAnchor, constant: 8).isActive = true
        dishImage.centerYAnchor.constraint(equalTo: extStack.centerYAnchor).isActive = true
        dishImage.heightAnchor.constraint(equalToConstant: innerStackWidth * 0.74).isActive = true
    }
}
