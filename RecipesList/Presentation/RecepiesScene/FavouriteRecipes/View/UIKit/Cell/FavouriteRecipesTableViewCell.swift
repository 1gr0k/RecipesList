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
    private var externalStack: UIStackView?
    private var innerStack: UIStackView?
    private var titleLabel: UILabel?
    
    override func prepareForReuse() {
        externalStack!.removeFromSuperview()
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
        
        self.titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.text = viewModel.title
        titleLabel!.numberOfLines = 2
        
        self.innerStack = UIStackView()
        innerStack!.translatesAutoresizingMaskIntoConstraints = false
        innerStack!.addSubview(titleLabel!)
        innerStack!.alignment = .center
        innerStack!.contentMode = .scaleToFill
        
        self.dishImageView = UIImageView()
        dishImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.externalStack = UIStackView()
        externalStack!.translatesAutoresizingMaskIntoConstraints = false
        externalStack!.distribution = .fillProportionally
        externalStack!.axis = .horizontal
        
        externalStack!.addSubview(innerStack!)
        externalStack!.addSubview(dishImageView!)
        self.addSubview(externalStack!)
        
        setupConstraints(innerStackWidth: innerStackWidth)
    }
    
    private func setupConstraints(innerStackWidth: Double) {
        externalStack!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        externalStack!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        externalStack!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        externalStack!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        innerStack!.topAnchor.constraint(equalTo: externalStack!.topAnchor).isActive = true
        innerStack!.bottomAnchor.constraint(equalTo: externalStack!.bottomAnchor).isActive = true
        innerStack!.leadingAnchor.constraint(equalTo: externalStack!.leadingAnchor).isActive = true
        innerStack!.trailingAnchor.constraint(equalTo: externalStack!.trailingAnchor, constant: -innerStackWidth).isActive = true
        
        titleLabel!.leadingAnchor.constraint(equalTo: innerStack!.leadingAnchor, constant: 8).isActive = true
        titleLabel!.trailingAnchor.constraint(equalTo: innerStack!.trailingAnchor, constant: -8).isActive = true
        titleLabel!.centerYAnchor.constraint(equalTo: innerStack!.centerYAnchor).isActive = true
        
        
        dishImageView!.trailingAnchor.constraint(equalTo: externalStack!.trailingAnchor).isActive = true
        dishImageView!.leadingAnchor.constraint(equalTo: innerStack!.trailingAnchor, constant: 8).isActive = true
        dishImageView!.centerYAnchor.constraint(equalTo: externalStack!.centerYAnchor).isActive = true
        dishImageView!.heightAnchor.constraint(equalToConstant: innerStackWidth * 0.74).isActive = true
    }
}
