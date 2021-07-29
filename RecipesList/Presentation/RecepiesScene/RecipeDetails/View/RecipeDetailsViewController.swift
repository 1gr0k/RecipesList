//
//  RecipeDetailsViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 22.07.2021.
//

import UIKit

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
        viewModel.recipe.observe(on: self) { [weak self] _ in self?.updateItems() }
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
            return CGSize(width: view.frame.width - 16, height: view.frame.width / 556 * 370)
        case 1:
            return CGSize(width: view.frame.width - 16, height: 50)
        case 2:
            return CGSize(width: Int((view.frame.width - 24) / 2), height: Int((view.frame.width - 24) / 2))
        default:
            return CGSize()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if section == 2 {
                return viewModel.recipe.value?.extIngredients.count ?? 0
            } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! RecipeDetailsHeaderViewCell
            cell.fill(with: viewModel.id, dishImageRepository: dishImageRepository)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typesCell", for: indexPath) as! RecipeDetailsTypesCollectionViewCell
            cell.fill(dishTypes: viewModel.recipe.value?.dishTypes ?? [])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientsCell", for: indexPath) as! RecipeDetailsIngredientsViewCell
            cell.fill(with: (viewModel.recipe.value?.extIngredients[indexPath.row] ?? ExtIngredient(id: 0, name: "")), dishImageRepository: dishImageRepository)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}
