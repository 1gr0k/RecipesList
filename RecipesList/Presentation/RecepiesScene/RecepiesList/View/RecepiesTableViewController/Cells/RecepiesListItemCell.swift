//
//  RecepiesListItemCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import UIKit
import SwiftUI
import Kingfisher

final class RecepiesListItemCell: UITableViewCell {
    
    let stackRatio = 0.3
    let imageRatio = 0.74
    lazy var imageWidth = {
        return (self.frame.width - 16.0) * self.stackRatio
    }
    let likeViewSize: CGFloat = 35
    
    var setLike: (() -> Void)?
    var removeLike: (() -> Void)?
    var didSelectItem: (() -> Void)?
    
    private var idLabel: UILabel!
    private var dishImageView: UIImageView!
    private var externalStack: UIStackView!
    private var innerStack: UIStackView!
    private var likeView: UIView!
    private var likeImage: UIImageView!
    private lazy var hoverView: UIView = {
        let view = UIView()
        view.frame.size = self.frame.size
        view.layer.cornerRadius = self.layer.cornerRadius
        view.backgroundColor = .systemGray.withAlphaComponent(0.2)
        return view
    }()
    
    static let reuseIdentifier = String(describing: RecepiesListItemCell.self)
    static let height = CGFloat(300)
    
    private var viewModel: RecepiesListItemViewModel!
    private var imageRepository: DishImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    override func prepareForReuse() {
        externalStack!.removeFromSuperview()
    }
    
    func fill(with viewModel: RecepiesListItemViewModel, dishImageRepository: DishImagesRepository?) {
        self.viewModel = viewModel
        self.imageRepository = dishImageRepository
        setupViews()
        updateDishImage()
        
        setLike = nil
        
    }
    
    private func updateDishImage() {
        dishImageView.image = nil
        let url  = URL(string: viewModel.image!)
        dishImageView.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: [.transition(.fade(0.3))])
    }
    
    private func setupViews() {
        
        self.backgroundColor = .systemGray5
        
        
        
        self.externalStack = UIStackView()
        externalStack.translatesAutoresizingMaskIntoConstraints = false
        externalStack.backgroundColor = .white
        externalStack.layer.cornerRadius = 25
        externalStack.layer.shadowColor = UIColor.black.cgColor
        externalStack.layer.shadowRadius = 3
        externalStack.layer.shadowOpacity = 0.2
        externalStack.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        self.innerStack = UIStackView()
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.likeView = UIView()
        likeView.translatesAutoresizingMaskIntoConstraints = false
        likeView.layer.cornerRadius = 15
        likeView.backgroundColor = viewModel.favourite ? .red : .white
        
        self.likeImage = UIImageView()
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        let likeIconImage = "heart"
        likeImage.image = UIImage(systemName: likeIconImage)
        likeImage.tintColor = viewModel.favourite ? .white : .red
        
        self.idLabel = UILabel()
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.numberOfLines = 3
        idLabel.font = .boldSystemFont(ofSize: 18)
        idLabel.text = viewModel.title
        
        self.dishImageView = UIImageView()
        dishImageView.translatesAutoresizingMaskIntoConstraints = false
        dishImageView.layer.cornerRadius = 15
        dishImageView.clipsToBounds = true
        
        self.addSubview(externalStack)
        externalStack.addSubview(innerStack)
        externalStack.addSubview(dishImageView)
        likeView.addSubview(likeImage)
        innerStack.addSubview(likeView)
        innerStack.addSubview(idLabel)
        
        setupConstrants()
        setupGestures()
    }
    
    func setupConstrants() {
        externalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        externalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        externalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        externalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        innerStack.leadingAnchor.constraint(equalTo: externalStack.leadingAnchor, constant: imageWidth() + 16).isActive = true
        innerStack.trailingAnchor.constraint(equalTo: externalStack.trailingAnchor).isActive = true
        innerStack.topAnchor.constraint(equalTo: externalStack.topAnchor).isActive = true
        innerStack.bottomAnchor.constraint(equalTo: externalStack.bottomAnchor).isActive = true
        
        likeView.centerYAnchor.constraint(equalTo: innerStack.centerYAnchor).isActive = true
        likeView.trailingAnchor.constraint(equalTo: innerStack.trailingAnchor, constant: -16).isActive = true
        likeView.widthAnchor.constraint(equalToConstant: likeViewSize).isActive = true
        likeView.heightAnchor.constraint(equalToConstant: likeViewSize).isActive = true
        
        likeImage.topAnchor.constraint(equalTo: likeView.topAnchor, constant: 7.5).isActive = true
        likeImage.leadingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: 7.5).isActive = true
        likeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        idLabel.centerYAnchor.constraint(equalTo: innerStack.centerYAnchor).isActive = true
        idLabel.leadingAnchor.constraint(equalTo: innerStack.leadingAnchor, constant: 16).isActive = true
        idLabel.trailingAnchor.constraint(equalTo: likeView.leadingAnchor, constant: -8).isActive = true
        
        dishImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dishImageView.leadingAnchor.constraint(equalTo: externalStack.leadingAnchor, constant: 16).isActive = true
        dishImageView.widthAnchor.constraint(equalToConstant: imageWidth()).isActive = true
        dishImageView.heightAnchor.constraint(equalToConstant: imageWidth() * imageRatio).isActive = true
    }
    
    private func setupGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 0
        longPressGesture.cancelsTouchesInView = true
        externalStack.addGestureRecognizer(longPressGesture)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapLike(_:)))
        gesture.minimumPressDuration = 0
        likeView.addGestureRecognizer(gesture)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .began :
        self.addSubview(hoverView)
    case .ended :
        onChangeRecognizerStack(sender) {
            self.hoverView.removeFromSuperview()
            guard let didSelectItem = self.didSelectItem else {
                return
            }
            didSelectItem()
        }
        
    case .changed:
        onChangeRecognizerStack(sender)
    @unknown default:
        return
    }
    }
    
    private func onChangeRecognizerStack(_ sender: UILongPressGestureRecognizer, completion: (()->Void)? = nil) {
        guard let senderView = sender.view else { return }
                let lastLocation = sender.location(in: senderView)
                guard senderView.bounds.contains(lastLocation) else {
                    hoverView.removeFromSuperview()
                    return
                }
        completion?()
    }
    
    @objc func tapLike(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            likeView.backgroundColor = .systemGray5
        case .ended:
            onChangeRecognizer(sender) {
                self.likeAnimation {
                    self.viewModel.favourite ? self.removeLike!() : self.setLike!()
                    self.viewModel.favourite.toggle()
                }
            }
        case .changed:
            onChangeRecognizer(sender)
        @unknown default:
            return
        }
    }
    
    private func onChangeRecognizer(_ sender: UILongPressGestureRecognizer, completion: (()->Void)? = nil) {
        guard let senderView = sender.view else { return }
                let lastLocation = sender.location(in: senderView)
                guard senderView.bounds.contains(lastLocation) else {
                    likeView.backgroundColor = viewModel.favourite ? .red : .white
                    return
                }

        completion?()
    }
    
    func likeAnimation(completion: @escaping () -> Void) {
        if !viewModel.favourite {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.7) {
                    self.likeView?.backgroundColor = .systemGray5
                }
                UIView.transition(with: self.likeImage, duration: 1.2, options: .transitionCrossDissolve) {
                    self.likeImage?.tintColor = .white
                }
                UIView.animate(withDuration: 0.5, delay: 0.7) { [weak self] in
                    self!.likeView?.backgroundColor = .red
                    completion()
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.transition(with: self.likeImage, duration: 0.5, options: .transitionCrossDissolve) {
                    self.likeImage?.tintColor = .red
                }
                
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self!.likeView?.backgroundColor = .white
                    completion()
                }
            }
        }
        
    }
}
