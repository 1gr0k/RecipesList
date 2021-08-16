//
//  RecipeDetailsViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import UIKit
import SwiftUI

private let imageRatio: Float = 370 / 556

class RecipeDetailsViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var testLabel: UILabel!
    private var viewModel: RecipeDetailsViewModel!
    private var dishImageRepository: DishImagesRepository!
    
    static func create(with viewModel: RecipeDetailsViewModel, dishImagesRepository: DishImagesRepository) -> RecipeDetailsViewController {
        let view = RecipeDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        view.dishImageRepository = dishImagesRepository
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bind(to: viewModel)
        setupViews()
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
    }
    
    private func bind(to viewModel: RecipeDetailsViewModel) {
        //        viewModel.recipe.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.dataSource.observe(on: self) { [weak self] _ in self?.updateItems() }
    }
    
    private func updateItems() {
        detailsCollectionView.reloadData()
    }
    
}


extension RecipeDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        detailsCollectionView.register(RecipeDetailsHeaderViewCell.self, forCellWithReuseIdentifier: "headerCell")
        detailsCollectionView.register(RecipeDetailsIngredientsViewCell.self, forCellWithReuseIdentifier: "ingredientsCell")
        detailsCollectionView.register(RecipeDetailsTypesCollectionViewCell.self, forCellWithReuseIdentifier: "typesCell")
        
        detailsCollectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.frame.width - 16, height: CGFloat(Int(Float(view.frame.width) * imageRatio)))
        case 1:
            return CGSize(width: view.frame.width - 16, height: 50)
        case 2:
            return CGSize(width: Int((view.frame.width - 24) / 2), height: Int((view.frame.width - 24) / 2))
        default:
            return CGSize()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.dataSource.value?.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionType(rawValue: section),
              let sectionModel = viewModel.dataSource.value?[section]
        else { return 0 }
        return sectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = SectionType(rawValue: indexPath.section),
              let sectionModels = viewModel.dataSource.value?[section]
        else { return UICollectionViewCell()}
        switch sectionModels[indexPath.row] {
            
        case is HeaderRecipeDeatilsCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as? RecipeDetailsHeaderViewCell,
                  let viewModel = sectionModels[indexPath.row] as? HeaderRecipeDeatilsCellViewModel
            else { return UICollectionViewCell()}
            cell.fill(with: viewModel.image, dishImageRepository: dishImageRepository)
            return cell
            
        case is DishTypesRecipeDetailsCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typesCell", for: indexPath) as? RecipeDetailsTypesCollectionViewCell,
                  let viewModel = sectionModels[indexPath.row] as? DishTypesRecipeDetailsCellViewModel
            else { return UICollectionViewCell()}
            cell.fill(dishTypes: viewModel.dishTypes)
            return cell
            
        case is ExtendedIngredientsRecipeDetailsCellViewModel:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientsCell", for: indexPath) as? RecipeDetailsIngredientsViewCell,
                  let viewModel = sectionModels[indexPath.row] as? ExtendedIngredientsRecipeDetailsCellViewModel
            else { return UICollectionViewCell()}
            cell.fill(with: ExtendedIngredient(model: viewModel), dishImageRepository: dishImageRepository)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}
