//
//  ViewController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import UIKit

final class RecepiesListViewController: UIViewController, StoryboardInstantiable, Alertable {
    

    @IBOutlet private var contentView: UIView!
    @IBOutlet private var recepiesListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private(set) var suggestionsListContainer: UIView!
    
    private var viewModel: RecepiesListViewModel!
    private var dishImagesRepository: DishImagesRepository?
    
    private var recepiesTabelViewController: RecepiesListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: RecepiesListViewModel, dishImagesRepository: DishImagesRepository?) -> RecepiesListViewController {
        let view = RecepiesListViewController.instantiateViewController()
        view.viewModel = viewModel
        view.dishImagesRepository = dishImagesRepository
        view.title = "Рецепты"
        view.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificatoinUpdateItems), name: NSNotification.Name(rawValue: "removeRecipeFromFavourite"), object: nil)
    }
    
    private func bind(to viewModel: RecepiesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0)}
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
        viewModel.checkTimer()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: RecepiesListTableViewController.self),
            let destinationVC = segue.destination as? RecepiesListTableViewController {
            recepiesTabelViewController = destinationVC
            recepiesTabelViewController?.viewModel = viewModel
            recepiesTabelViewController?.dishImageRepository = dishImagesRepository
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        title = viewModel.screenTitle
        setupSearchController()
    }
    
    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }

    private func updateItems() {
        recepiesTabelViewController?.reload()
    }
    
    private func updateLoading(_ loading: RecepiesListViewModelLoading?) {
        recepiesListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        LoadingView.hide()
        
        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: recepiesListContainer.isHidden = false
        case .none:
            recepiesListContainer.isHidden = viewModel.isEmpty
        }
        recepiesTabelViewController?.updateLoading(loading)
    }
    
    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }
    
    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

extension RecepiesListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
    }
}

extension RecepiesListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtinCliked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
    
}

extension RecepiesListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}

extension RecepiesListViewController {
    @objc private func notificatoinUpdateItems() {
        viewModel.refresh()
    }
}
