//
//  FavouriteRecipesTableViewCell.swift
//  FavouriteRecipesTableViewCell
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit

class FavouriteRecipesTableViewCell: UITableViewCell {
    
    var didSelectItem: (() -> Void)!
    var removeLike: (() -> Void)!
    
    static let reuseIdentifier = String(describing: FavouriteRecipesTableViewCell.self)
    
    private var viewModel: RecepiesListItemViewModel!
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    private var dishImageView: UIImageView!
    private var externalStack: UIStackView!
    private var innerStack: UIStackView!
    private var titleLabel: UILabel!
    private var likeView: UIView!
    private var likeImage: UIImageView!
    
    override func prepareForReuse() {
        externalStack.removeFromSuperview()
    }
    
    func fill(with viewModel: RecepiesListItemViewModel, dishImageRepository: DishImagesRepository?) {
        self.viewModel = viewModel
        self.imageRepository = dishImageRepository
        setupViews()
        updateDishImage()
    }
    
    private func updateDishImage() {
        dishImageView.image = nil
        guard let imagePath = viewModel.id else { return }
        
        imageLoadTask = imageRepository?.fetchImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.id == imagePath else { return }
            if case let .success(data) = result {
                self.dishImageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    
    func setupViews() {
        
        self.backgroundColor = .systemGray5
        
        let stacksRatio = 0.3
        let imageRatio = 0.74
        let imageWidth = (self.frame.width - 16.0) * stacksRatio
        
        self.titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 3
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        self.innerStack = UIStackView()
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        innerStack.alignment = .center
        innerStack.contentMode = .scaleToFill
        
        self.dishImageView = UIImageView()
        dishImageView.translatesAutoresizingMaskIntoConstraints = false
        dishImageView.layer.cornerRadius = 15
        dishImageView.clipsToBounds = true
        
        self.externalStack = recipeStack()
        externalStack.translatesAutoresizingMaskIntoConstraints = false
        externalStack.distribution = .fillProportionally
        externalStack.axis = .horizontal
        externalStack.backgroundColor = .white
        externalStack.layer.cornerRadius = 25
        externalStack.layer.shadowColor = UIColor.black.cgColor
        externalStack.layer.shadowRadius = 3
        externalStack.layer.shadowOpacity = 0.2
        externalStack.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.likeView = UIView()
        likeView.translatesAutoresizingMaskIntoConstraints = false
        likeView.layer.cornerRadius = 15
        likeView.backgroundColor = .systemGray4
        likeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.removeLike(_:))))
        
        self.likeImage = UIImageView()
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        let likeIconImage = "trash"
        likeImage.image = UIImage(systemName: likeIconImage)
        likeImage.tintColor = .white
        
        likeView.addSubview(likeImage)
        innerStack.addSubview(likeView)
        innerStack.addSubview(titleLabel)
        externalStack.addSubview(innerStack)
        externalStack.addSubview(dishImageView)
        self.addSubview(externalStack)
        
        setupConstraints(imageWidth: imageWidth, imageRatio: imageRatio)
    }
    
    private func setupConstraints(imageWidth: Double, imageRatio: Double) {
        externalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        externalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        externalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        externalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        externalStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapRecipe(_:))))
        
        innerStack.topAnchor.constraint(equalTo: externalStack.topAnchor).isActive = true
        innerStack.bottomAnchor.constraint(equalTo: externalStack.bottomAnchor).isActive = true
        innerStack.leadingAnchor.constraint(equalTo: externalStack.leadingAnchor, constant: imageWidth + 16).isActive = true
        innerStack.trailingAnchor.constraint(equalTo: externalStack.trailingAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: innerStack.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: -8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: innerStack.centerYAnchor).isActive = true
        
        dishImageView.centerYAnchor.constraint(equalTo: externalStack.centerYAnchor).isActive = true
        dishImageView.leadingAnchor.constraint(equalTo: externalStack.leadingAnchor, constant: 16).isActive = true
        dishImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        dishImageView.heightAnchor.constraint(equalToConstant: imageWidth * imageRatio).isActive = true
        
        likeView.centerYAnchor.constraint(equalTo: innerStack.centerYAnchor).isActive = true
        likeView.trailingAnchor.constraint(equalTo: innerStack.trailingAnchor, constant: -16).isActive = true
        likeView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        likeView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        likeImage.topAnchor.constraint(equalTo: likeView.topAnchor, constant: 7.5).isActive = true
        likeImage.leadingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: 7.5).isActive = true
        likeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func tapRecipe(_ sender: UITapGestureRecognizer) {
        didSelectItem()
    }
    
    @objc func removeLike(_ sender: UITapGestureRecognizer) {
        removeLike()
    }
}
