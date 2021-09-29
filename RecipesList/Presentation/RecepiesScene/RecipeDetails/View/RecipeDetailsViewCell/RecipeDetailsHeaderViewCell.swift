//
//  RecipeDetailsHeaderViewCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 27.07.2021.
//

import Foundation
import UIKit
import Kingfisher

class RecipeDetailsHeaderViewCell: UICollectionViewCell {
    
    private var imageSource: String?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    func fill(with imageSource: String) {
        self.imageSource = imageSource
        setupImage()
    }
    
    func setupImage() {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        let url = URL(string: imageSource!)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: [.transition(.fade(0.3))])
        
    }
}
