//
//  FavouriteRecipesTableViewController.swift
//  FavouriteRecipesTableViewController
//
//  Created by Андрей Калямин on 04.08.2021.
//

import UIKit
import InjectPropertyWrapper

class FavouriteRecipesTableViewController: UITableViewController, StoryboardInstantiable {
    
    @Inject private var viewModel: FavouriteRecipesViewModel
    private var tableViewManager: RecipesListTableManager?
    
    @Inject var dishImagesRepository: DishImagesRepository

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidload()
        setupUI()
        bind(to: viewModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewDesappear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    static func create() -> FavouriteRecipesTableViewController {
        let view = FavouriteRecipesTableViewController.instantiateViewController()
        
        NotificationCenter.default.addObserver(view, selector: #selector(notificationUpdateItems), name: NSNotification.Name(rawValue: "FavouriteListChanged"), object: nil)
        return view
    }
    
    func setupActions(actions: RecepiesListViewModelActions) {
        viewModel.setupActions(actions: actions)
    }

    func setupUI(){
        tableViewManager = RecipesListTableManager(tableView: tableView, data: viewModel.items.value, viewModel: viewModel)
        self.view.backgroundColor = .systemGray5
    }
    
    private func bind(to viewModel: FavouriteRecipesViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0)}
    }

    private func updateItems() {
        tableViewManager?.update(models: viewModel.items.value)
    }
    
    @objc func notificationUpdateItems() {
        viewModel.refresh()
    }
    
    private func updateLoading(_ loading: RecepiesListViewModelLoading?) {
        LoadingView.hide()
        
        switch loading {
        case .fullScreen: LoadingView.show()
        case .none, .some:
            return
        }
    }
    
}
