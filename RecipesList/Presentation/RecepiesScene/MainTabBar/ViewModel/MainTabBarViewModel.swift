//
//  MainTabBarViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.07.2021.
//

import Foundation
import UIKit

protocol MainTabBarViewModelInput {
    func viewDidLoad()
}

protocol MainTabBarViewModelOutput {
    
}

protocol MainTabBarViewModel: MainTabBarViewModelInput, MainTabBarViewModelOutput { }

class DefaultMainTabBarViewModel: MainTabBarViewModel {
    
    init(views: [UINavigationController]) {
        for view in views {
            if let viewVC = view.viewControllers.first {
                switch viewVC {
                case is RecepiesListViewController :
                    viewVC.title = "Рецепты"
                    viewVC.tabBarItem.image = UIImage(systemName: "list.bullet")
                case is FavouriteRecipesTableViewController :
                    viewVC.title = "Избранное"
                    viewVC.tabBarItem.image = UIImage(systemName: "heart")
                default:
                    return
                }
            }
        }
    }
    
    func viewDidLoad() {
//        print("didLoad")
    }
}
