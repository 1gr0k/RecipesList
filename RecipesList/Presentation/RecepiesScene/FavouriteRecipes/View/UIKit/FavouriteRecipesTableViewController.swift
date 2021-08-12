//
//  FavouriteRecipesTableViewController.swift
//  FavouriteRecipesTableViewController
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit

class FavouriteRecipesTableViewController: UITableViewController, StoryboardInstantiable {
    
    private var viewModel: FavouriteRecipesViewModel!
    private var tableViewManager: RecipesListTableManager?
    
    var dishImagesRepository: DishImagesRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidload()
        setupUI()
        bind(to: viewModel)
        NotificationCenter.default.addObserver(self, selector: #selector(updateItems), name: NSNotification.Name(rawValue: "update"), object: nil)
        
    }
    
    static func create(viewModel: FavouriteRecipesViewModel, dishImagesRepository: DishImagesRepository?) -> FavouriteRecipesTableViewController {
        let view = FavouriteRecipesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        view.dishImagesRepository = dishImagesRepository
        return view
    }

    func setupUI(){
        tableViewManager = RecipesListTableManager(tableView: tableView, data: viewModel.items.value, dishImageRepository: dishImagesRepository!, viewModel: viewModel)
        self.title = "Favorite recipes"
//        self.edgesForExtendedLayout = 
    }
    
    private func bind(to viewModel: FavouriteRecipesViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
//        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0)}
//        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
//        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }

    @objc private func updateItems() {
        tableViewManager?.update(models: viewModel.items.value)
    }
    
    
}
