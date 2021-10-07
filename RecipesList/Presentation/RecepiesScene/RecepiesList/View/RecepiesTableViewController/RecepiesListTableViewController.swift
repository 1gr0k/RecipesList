//
//  RecepiesListTableViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit
import SwiftUI

class RecepiesListTableViewController: UITableViewController {
    
    var viewModel: RecepiesListViewModel!
    
    var nextPageLoadingSpinner: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func updateLoading(_ loading: RecepiesListViewModelLoading?) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
    
    //MARK: - Private
    
    private func setupViews() {
        tableView.estimatedRowHeight = RecepiesListItemCell.height
        tableView.rowHeight = 150
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
    }


}

extension RecepiesListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecepiesListItemCell.reuseIdentifier, for: indexPath) as? RecepiesListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(RecepiesListItemCell.self) with reuseIdentifier: \(RecepiesListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.fill(with: viewModel.items[indexPath.row])
        cell.setLike = {
            self.viewModel.setLike(id: self.viewModel.items[indexPath.row].id!)
        }
        cell.removeLike = {
            self.viewModel.removeLike(id: self.viewModel.items[indexPath.row].id!)
        }
        cell.didSelectItem = {
            self.viewModel.didSelectItem(at: indexPath.row)
        }
        
        if indexPath.row == viewModel.items.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }
}

extension RecepiesListTableViewController {

    private func handleMarkAsFavourite(index: Int) {
        viewModel.setLike(id: viewModel.items[index].id!)
    }

    private func handleRemoveFromFavourite(index: Int) {
        viewModel.removeLike(id: viewModel.items[index].id!)
    }
}
