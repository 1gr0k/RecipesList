//
//  FavouriteRecipesListView.swift
//  FavouriteRecipesListView
//
//  Created by Андрей Калямин on 11.08.2021.
//

import SwiftUI
import InjectPropertyWrapper

struct FavouriteRecipesListView: View {
    
    @ObservedObject var viewModelWrapper: FavouriteRecipesListViewModelWrapper
    var dishImagesRepository: DishImagesRepository?
    
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Favorite recipes")
                .font(.title)
                .padding(.leading, 16)
                
        List(viewModelWrapper.items) { recept in
            if #available(iOS 15.0, *) {
                HStack(alignment: .center){
                    HStack{
                        Text(recept.title!)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .scaledToFit()
                    Spacer()
                    AsyncImage(url: recept.id, placeholder: {
                        ProgressView()
                        
                    }).aspectRatio(contentMode: .fit)
                }
                .frame(height: 75)
                .listRowSeparator(.hidden)
                .swipeActions(edge: .leading) {
                    Button(role: .destructive) {

                        viewModelWrapper.viewModel?.removeLike(id: recept.id, title: recept.title!)
                    }
                label: {
                        Label("Delete", systemImage: "trash")

                    }
                    .foregroundColor(.red)

                }
            }
        }
        .animation(.linear, value: viewModelWrapper.items)
        .listStyle(.inset)
        .onAppear {
            viewModelWrapper.viewModel?.viewDidload()
        }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: String
    @Inject private var dishImagesRepository: DishImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    
    init(url: String) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    private var cancellable: Cancellable?
    
    func load() {
        
        imageLoadTask = dishImagesRepository.fetchImage(with: url) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    @Inject private var dishImagesRepository: DishImagesRepository
    
    init(url: String, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}


final class FavouriteRecipesListViewModelWrapper: ObservableObject {
    var viewModel: FavouriteRecipesViewModel?
    @Published var items: [FavouriteRecept] = []
    
    init(viewModel: FavouriteRecipesViewModel?) {
        self.viewModel = viewModel
        viewModel?.items.observe(on: self) { [weak self] values in self?.items = values }
    }
}
