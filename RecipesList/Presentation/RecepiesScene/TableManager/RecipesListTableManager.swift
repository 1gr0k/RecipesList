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
        tableView.backgroundColor = .systemGray5
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear

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
        cell.didSelectItem = {
            self.viewModel?.didSelectItem(at: indexPath.row)
        }
        cell.removeLike = { [self] in
            self.viewModel?.removeLike(id: (viewModel?.items.value[indexPath.row].id)!, title: (viewModel?.items.value[indexPath.row].title)!)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel!.didSelectItem(at: indexPath.row)
    }
    
}

