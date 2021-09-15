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
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 230)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    private lazy var timerView: TimerView = {
        let timerView = TimerView()
        timerView.setupMinutes(in: viewModel?.readyInMinutes ?? 0)
        return timerView
    }()
    
    private lazy var timerViewCell: TimerViewCell = {
        let timerViewCell = TimerViewCell()
        return timerViewCell
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
        timerViewCell.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timerView)
        timerViewCell.proxyView!.timerView.addSubview(timerView)
//        timerViewCell.addSubview(timerView)
        addSubview(timerViewCell)
        addSubview(imageView)
        
        setupTimerViewCellConstraint(timerCell: timerViewCell)
        setupTimerConstraint(timer: timerView)
    }
    
    private func setupTimerConstraint(timer: TimerView) {
        NSLayoutConstraint.activate([
            timer.heightAnchor.constraint(equalToConstant: 150),
            timer.widthAnchor.constraint(equalToConstant: 150),
            timer.topAnchor.constraint(equalTo: timerViewCell.proxyView!.timerView.topAnchor),
            timer.leadingAnchor.constraint(equalTo: timerViewCell.proxyView!.timerView.leadingAnchor)
        ])
    }
    
    private func setupTimerViewCellConstraint(timerCell: TimerViewCell) {
        NSLayoutConstraint.activate([
            timerCell.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            timerCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            timerCell.heightAnchor.constraint(equalToConstant: 220),
            timerCell.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
