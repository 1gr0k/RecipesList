//
//  RecepiesListViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct RecepiesListViewModelActions {
    let showReceptDetails: (Recept) -> Void
}

enum RecepiesListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol RecepiesListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
    
}

protocol RecepiesListViewModelOutput {
    var items: Observable<[RecepiesListItemViewModel]> { get }
    var loading: Observable<RecepiesListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol RecepiesListViewModel: RecepiesListViewModelOutput, RecepiesListViewModelInput {}

final class DefaultRecepiesListViewModel: RecepiesListViewModel{
    
    private let searchRecepiesUseCase: SearchRecepiesUseCase
    private let actions: RecepiesListViewModelActions?
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    
    var hasMorePages: Bool {
                                            print("hasMorePages: \(currentPage < totalPageCount)")
                                            return currentPage < totalPageCount
    }
    var nextPage: Int {
        print("nextPage: \(hasMorePages ? currentPage + 1 : currentPage)")
        return hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [RecepiesPage] = []
    private var recepiesLoadTask: Cancellable? { willSet {recepiesLoadTask?.cancel() } }
    
    // MARK: Output
    let items: Observable<[RecepiesListItemViewModel]> = Observable([])
    let loading: Observable<RecepiesListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = "Рецепты"
    let errorTitle = String("Error")
    let searchBarPlaceholder = String("Search recepies")
    
    //MARK: Init
    
    init(searchReceptUseCase: SearchRecepiesUseCase,
         actions: RecepiesListViewModelActions? = nil) {
        self.searchRecepiesUseCase = searchReceptUseCase
        self.actions = actions
    }
    
    //MARK: - Private
    
    private func appendPage(_ recepiesPage: RecepiesPage) {
        currentPage = recepiesPage.page
        totalPageCount = recepiesPage.totalPages
        
        pages = pages
            .filter { $0.page != recepiesPage.page } + [recepiesPage]
        
        items.value = pages.recepies.map(RecepiesListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(receptQuery: ReceptQuery, loading: RecepiesListViewModelLoading) {
        self.loading.value = loading
        query.value = receptQuery.query

        recepiesLoadTask = searchRecepiesUseCase.execute(
            requestValue: .init(query: receptQuery, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading recepies", comment: "")
    }
    
    private func update(receptQuery: ReceptQuery) {
        resetPages()
        load(receptQuery: receptQuery, loading: .fullScreen)
    }
}

extension DefaultRecepiesListViewModel {
    func viewDidLoad() {
        query.value = "Pasta"
        update(receptQuery: ReceptQuery(query: query.value))
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(receptQuery: .init(query: query.value), loading: .nextPage)
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(receptQuery: ReceptQuery(query: query))
    }

    func didCancelSearch() {
        recepiesLoadTask?.cancel()
    }

    func showQueriesSuggestions() {

    }

    func closeQueriesSuggestions() {

    }

    func didSelectItem(at index: Int) {
        actions?.showReceptDetails(pages.recepies[index])
    }
    
}

//MARK: Private

private extension Array where Element == RecepiesPage {
    var recepies: [Recept] { flatMap { $0.recepies } }
}
