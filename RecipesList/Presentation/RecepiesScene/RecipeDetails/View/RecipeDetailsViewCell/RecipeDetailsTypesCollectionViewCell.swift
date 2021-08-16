//
//  RecipeDetailsCollectionViewCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 27.07.2021.
//

import UIKit

class RecipeDetailsTypesCollectionViewCell: UICollectionViewCell {
    
    private var scrollLink: UIScrollView?
    
    func fill(dishTypes: [String]) {
        
        setupStack(dishTypes: dishTypes)
    }
    override func prepareForReuse() {
        scrollLink?.removeFromSuperview()
    }
    
    private func setupStack(dishTypes: [String]) {
        
        let scrollView = UIScrollView()
        self.scrollLink = scrollView
        let stackView = UIStackView()
        
        scrollView.addSubview(stackView)
        
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        for dishType in dishTypes {
            setupDishTypeView(dishType: dishType, stackView: stackView)
        }
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.spacing   = 8
    }
    
    func setupDishTypeView(dishType: String, stackView: UIStackView) {
        let view = UIView()
        let label = UILabel()
        
        view.addSubview(label)
        stackView.addArrangedSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = dishType
        
        view.backgroundColor = .gray
        view.layer.cornerRadius = 5
        view.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -10).isActive = true
        view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant:  10).isActive = true
        view.topAnchor.constraint(equalTo: label.topAnchor, constant: -5).isActive = true
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant:  5).isActive = true
    }
}

