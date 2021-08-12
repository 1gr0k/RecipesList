//
//  RecipesListTableManager.swift
//  RecipesListTableManager
//
//  Created by Андрей Калямин on 04.08.2021.
//

import Foundation
import UIKit

final class RecipesListTableManager: NSObject {

    private unowned var tableView: UITableView!
    private var dataSource: [Any]
    private var dishImageRepository: DishImagesRepository
    private var viewModel: FavouriteRecipesViewModel?

    init(tableView: UITableView, data: [Any], dishImageRepository: DishImagesRepository, viewModel: FavouriteRecipesViewModel) {
        self.tableView = tableView
        self.dishImageRepository = dishImageRepository
        dataSource = data
        super.init()
        setupTableView()
        tableView.reloadData()
        self.viewModel = viewModel
    }
    
    func update(models: [Any]) {
        dataSource = models
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.backgroundColor = .white

    }
}

extension RecipesListTableManager: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteRecipesTableViewCell.reuseIdentifier, for: indexPath) as? FavouriteRecipesTableViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(FavouriteRecipesTableViewCell.self) with reuseIdentifier: \(FavouriteRecipesTableViewCell.reuseIdentifier)")
            return UITableViewCell()
        }
        let model = dataSource[indexPath.row] as! FavouriteRecept
        cell.fill(with: RecepiesListItemViewModel(id: model.id, title: model.title!, image: model.id, favourite: true), dishImageRepository: dishImageRepository)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
            let action = UIContextualAction(style: .destructive,
                                            title: "remove from Favourite") { [weak self] (action, view, completionHandler) in
                self?.handleRemoveFromFavourite(index: indexPath.row)
                completionHandler(true)
            }
            action.backgroundColor = .systemRed
            actions.append(action)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    private func handleRemoveFromFavourite(index: Int) {
        viewModel!.removeLike(id: viewModel!.items.value[index].id, title: viewModel!.items.value[index].title!)
//        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

