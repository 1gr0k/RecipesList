//
//  MainTabBarController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.07.2021.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, StoryboardInstantiable {
    
    private var viewModel: MainTabBarViewModel!
    private var views: [UIViewController]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel.viewDidLoad()
    }
    
    func setupViews() {
        self.viewControllers = views
    }
    
    static func create(viewModel: MainTabBarViewModel, views: [UIViewController]) -> MainTabBarController {
        let view = MainTabBarController.instantiateViewController()
        view.viewModel = viewModel
        view.views = views
    
        return view
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
