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
    
    var dishImageRepository: DishImagesRepository?
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
        tableView.rowHeight = UITableView.automaticDimension
    }


}

extension RecepiesListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecepiesListItemCell.reuseIdentifier, for: indexPath) as? RecepiesListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(RecepiesListItemCell.self) with reuseIdentifier: \(RecepiesListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.fill(with: viewModel.items.value[indexPath.row], dishImageRepository: dishImageRepository)
        
        if indexPath.row == viewModel.items.value.count - 1 {
            viewModel.didLoadNextPage()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }

}

extension RecepiesListTableViewController {

    private func handleMarkAsFavourite(index: Int) {
        viewModel.setLike(id: viewModel.items.value[index].id!)
    }

    private func handleRemoveFromFavourite(index: Int) {
        viewModel.removeLike(id: viewModel.items.value[index].id!)
    }

    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        if viewModel.items.value[indexPath.row].favourite! {
            let action = UIContextualAction(style: .destructive,
                                            title: "remove from Favourite") { [weak self] (action, view, completionHandler) in
                self?.handleRemoveFromFavourite(index: indexPath.row)
                completionHandler(true)
            }
            action.backgroundColor = .systemRed
            actions.append(action)
        } else {
            let action = UIContextualAction(style: .normal,
                                            title: "Favourite") { [weak self] (action, view, completionHandler) in
                self?.handleMarkAsFavourite(index: indexPath.row)
                completionHandler(true)
            }
            action.backgroundColor = .systemBlue
            actions.append(action)
        }

        return UISwipeActionsConfiguration(actions: actions)
    }
}
