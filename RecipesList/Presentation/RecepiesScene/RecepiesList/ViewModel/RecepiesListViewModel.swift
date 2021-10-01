//
//  RecepiesListViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation
import InjectPropertyWrapper

struct RecepiesListViewModelActions {
    let showRecipeDetails: (String) -> Void
    let showApiError: (ApiErrorDelegate) -> Void
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
    func setLike(id: String)
    func removeLike(id: String)
    func refresh()
    func viewDisappear()
    func showApiError()
    func setupActions(actions: RecepiesListViewModelActions?)
    func createQRScanerController() -> QRScanerViewController
    func showDetailRecipe(id: String)
}

protocol RecepiesListViewModelOutput {
    var items: [RecepiesListItemViewModel] { get }
    var loading: Observable<RecepiesListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var onRefresh: Observable<Void> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol RecepiesListViewModel: RecepiesListViewModelOutput, RecepiesListViewModelInput {}

final class DefaultRecipesListViewModel: RecepiesListViewModel, ApiErrorDelegate, QRScanerDelegate{
    
    let onRefresh: Observable<Void> = Observable({}())
    
    static let itemsPerPage = 10
    
    @Inject private var favouriteRecepiesUseCase: RecipesListWithFavouritesUseCase
    private var actions: RecepiesListViewModelActions?
    private var timer: Timer?
    
    @Inject private var setLikeInteractor: SetLikeInteractor
    @Inject private var removeLikeInteractor: RemoveLikeInteractor
    
    var currentPage: Int = 0
    var totalPageCount: Int = 1
    
    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    var nextPage: Int {
        return hasMorePages ? currentPage + 1 : currentPage }
    
    private var pages: [RecepiesPage] = []
    private var recepiesLoadTask: Cancellable? { willSet {recepiesLoadTask?.cancel() } }
    
    // MARK: Output
    var items: [RecepiesListItemViewModel] = []
    let loading: Observable<RecepiesListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.isEmpty }
    let screenTitle = "Рецепты"
    let errorTitle = String("Error")
    let searchBarPlaceholder = String("Search recepies")
    
    //MARK: Init
    
    func setupActions(actions: RecepiesListViewModelActions? = nil) {
        self.actions = actions
    }
    
    //MARK: - Private
    
    private func appendPage(_ recepiesPage: RecepiesPage) {
        currentPage = recepiesPage.page
        totalPageCount = recepiesPage.totalPages
        
        pages = pages
            .filter { $0.page != recepiesPage.page } + [recepiesPage]
        items = pages.recepies.map(RecepiesListItemViewModel.init)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.removeAll()
    }
    
    private func load(receptQuery: RecipeQuery, loading: RecepiesListViewModelLoading) {
        self.loading.value = loading
        query.value = receptQuery.query
        
        recepiesLoadTask = favouriteRecepiesUseCase.execute(
            requestValue: .init(query: receptQuery, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                    self.onRefresh.value = {}()
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
            })
    }
    
    private func handle(error: Error) {
        let error = ErrorType(error: error as! NetworkError)
        self.error.value = error.errorMessage
    }
    
    private func update(receptQuery: RecipeQuery) {
        resetPages()
        load(receptQuery: receptQuery, loading: .fullScreen)
    }
    
    func update() {
        update(receptQuery: RecipeQuery(query: query.value))
    }
}

extension DefaultRecipesListViewModel {
    func viewDidLoad() {
        query.value = "Pizza"
        update(receptQuery: RecipeQuery(query: query.value))
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(receptQuery: .init(query: query.value), loading: .nextPage)
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(receptQuery: RecipeQuery(query: query))
    }
    
    func didCancelSearch() {
        recepiesLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        
    }
    
    func closeQueriesSuggestions() {
        
    }
    
    func didSelectItem(at index: Int) {
        actions?.showRecipeDetails(pages.recepies[index].id)
    }
    
    func refresh() {
        viewDidLoad()
    }
    
    func showApiError() {
        actions?.showApiError(self)
    }
    
}

extension DefaultRecipesListViewModel {
    func setLike(id: String) {
        
        setLikeInteractor.setLike(id: id, completion: {
            self.items = self.items.map({
                
                $0.id == id ? .init(id: $0.id, title: $0.title, image: $0.image, favourite: true) : $0
            })
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.favouriteListChangedNotification), userInfo: nil, repeats: false)
            }
        })
    }
    
    func removeLike(id: String) {
        removeLikeInteractor.removeLike(id: id, completion: {
            self.items = self.items.map({
                $0.id == id ? .init(id: $0.id, title: $0.title, image: $0.image, favourite: false) : $0
            })
            DispatchQueue.main.async {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.favouriteListChangedNotification), userInfo: nil, repeats: false)
            }
        })
    }
    
    @objc private func favouriteListChangedNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavouriteListChanged"), object: nil)
        timer = nil
    }
    
    internal func viewDisappear() {
        if timer != nil {
            timer?.invalidate()
            favouriteListChangedNotification()
        }
    }
    
    func createQRScanerController() -> QRScanerViewController {
        let qrScaner = AppDelegate.container.resolve(QRScanerViewController.self, argument: self as! QRScanerDelegate)!
        return qrScaner
    }
    
    func showDetailRecipe(id: String) {
        actions?.showRecipeDetails(id)
    }
    
}

//MARK: Private

private extension Array where Element == RecepiesPage {
    var recepies: [Recipe] { flatMap { $0.recepies } }
}

extension DefaultRecipesListViewModel {
    enum ErrorType {
    case apiKey
    case available
    case connectionError
    case wrongRecipe
    case defaultError

        var errorMessage: String {
            switch self {
            case .apiKey:
                return "Некорректный ключ API"
            case .available:
                return "Достигнут дневной лимит запросов ключа"
            case .connectionError:
                return "Отсутствует интернет соединение"
            case .wrongRecipe:
                return "Данные о данном рецепте отсутствуют"
            default:
                return "Что-то пошло не так"
            }
        }
        
        init(error: NetworkError) {
            switch error {
            case .unathorized:
                self = .apiKey
            case .requestLimit:
                self = .available
            case .notConnected:
                self = .connectionError
            case .wrongRecipe:
                self = .wrongRecipe
            default:
                self = .defaultError
            }
        }
    }
}
