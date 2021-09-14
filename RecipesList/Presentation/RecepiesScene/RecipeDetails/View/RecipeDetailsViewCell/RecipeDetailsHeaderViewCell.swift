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
    private var viewModel: HeaderRecipeDeatilsCellViewModel?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 150)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    private lazy var timerView: TimerView = {
        let timerView = TimerView()
        timerView.setupMinutes(in: viewModel?.readyInMinutes ?? 0)
        return timerView
    }()
    
    func fill(with viewmodel: HeaderRecipeDeatilsCellViewModel, dishImageRepository: DishImagesRepository?) {
        self.imageSource = viewmodel.image
        self.imageRepository = dishImageRepository
        self.viewModel = viewmodel
        setupViews()
        updateDishImage()
    }
    
    private func updateDishImage() {
        
        guard let imagePath = self.imageSource else { return }
        
        imageLoadTask = imageRepository?.fetchDetailImage(with: imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.imageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    
    private func setupViews() {
        timerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerView)
        addSubview(imageView)
        setupTimerConstraint(timer: timerView)
    }
    
    private func setupTimerConstraint(timer: TimerView) {
        NSLayoutConstraint.activate([
            timer.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            timer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timer.heightAnchor.constraint(equalToConstant: 150),
            timer.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
