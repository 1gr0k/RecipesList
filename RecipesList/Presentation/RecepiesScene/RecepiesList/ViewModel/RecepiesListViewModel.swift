//
//  RecepiesListViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct RecepiesListViewModelActions {
    let showRecipeDetails: (String) -> Void
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
    func checkTimer()
    
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

final class DefaultRecipesListViewModel: RecepiesListViewModel{
    
    private let favouriteRecepiesUseCase: RecipesListWithFavouritesUseCase
    private let actions: RecepiesListViewModelActions?
    private let setLikeInteractor: SetLikeInteractor?
    private let removeLikeInteractor: RemoveLikeInteractor?
    private var timer: Timer?
    
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
    
    init(favouriteRecipesUseCase: RecipesListWithFavouritesUseCase,
         actions: RecepiesListViewModelActions? = nil, setLikeInteractor: SetLikeInteractor, removeLikeInteractor: RemoveLikeInteractor) {
        self.favouriteRecepiesUseCase = favouriteRecipesUseCase
        self.actions = actions
        self.setLikeInteractor = setLikeInteractor
        self.removeLikeInteractor = removeLikeInteractor
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
    
    private func update(receptQuery: RecipeQuery) {
        resetPages()
        load(receptQuery: receptQuery, loading: .fullScreen)
    }
}

extension DefaultRecipesListViewModel {
    func viewDidLoad() {
        query.value = "Pasta"
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
        print("element in favourite deleted")
        viewDidLoad()
    }
    
}

extension DefaultRecipesListViewModel {
    func setLike(id: String) {
        
        let queue = DispatchQueue(label: "setLikeQueue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        
        queue.sync {
            semaphore.wait()
            setLikeInteractor?.setLike(id: id, completion: {
                print("Set like")
                semaphore.signal()
            })
            
        }
        queue.sync {
            semaphore.wait()
            self.items.value = self.items.value.map({
                $0.id == id ? .init(id: $0.id, title: $0.title, image: $0.image, favourite: true) : $0
            })
            semaphore.signal()
        }
        queue.sync {
            semaphore.wait()
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(favouriteListChangedNotification), userInfo: nil, repeats: false)
            semaphore.signal()
        }
        
    }
    
    func removeLike(id: String) {
        
        let queue = DispatchQueue(label: "setLikeQueue", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 1)
        queue.sync {
            semaphore.wait()
            removeLikeInteractor?.removeLike(id: id, completion: {
                print("delete like")
                semaphore.signal()
            })
        }
        
        queue.sync {
            semaphore.wait()
            self.items.value = self.items.value.map({
                $0.id == id ? .init(id: $0.id, title: $0.title, image: $0.image, favourite: false) : $0
            })
            semaphore.signal()
        }
        
        queue.sync {
            semaphore.wait()
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(favouriteListChangedNotification), userInfo: nil, repeats: false)
            semaphore.signal()
        }
    }
    
    @objc private func favouriteListChangedNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FavouriteListChanged"), object: nil)
    }
    
    internal func checkTimer() {
        if timer != nil {
            timer?.invalidate()
            favouriteListChangedNotification()
        }
    }
}

//MARK: Private

private extension Array where Element == RecepiesPage {
    var recepies: [Recipe] { flatMap { $0.recepies } }
}
