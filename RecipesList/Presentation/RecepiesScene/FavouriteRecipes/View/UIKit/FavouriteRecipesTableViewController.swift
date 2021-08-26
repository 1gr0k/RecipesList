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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.checkTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func create(viewModel: FavouriteRecipesViewModel, dishImagesRepository: DishImagesRepository?) -> FavouriteRecipesTableViewController {
        let view = FavouriteRecipesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        view.dishImagesRepository = dishImagesRepository
        
        NotificationCenter.default.addObserver(view, selector: #selector(notificationUpdateItems), name: NSNotification.Name(rawValue: "FavouriteListChanged"), object: nil)
        return view
    }

    func setupUI(){
        tableViewManager = RecipesListTableManager(tableView: tableView, data: viewModel.items.value, dishImageRepository: dishImagesRepository!, viewModel: viewModel)
        self.view.backgroundColor = .systemGray5
    }
    
    private func bind(to viewModel: FavouriteRecipesViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
    }

    private func updateItems() {
        tableViewManager?.update(models: viewModel.items.value)
    }
    
    @objc func notificationUpdateItems() {
        viewModel.refresh()
    }
    
    
}
