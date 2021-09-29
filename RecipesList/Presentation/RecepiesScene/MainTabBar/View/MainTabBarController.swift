//
//  MainTabBarController.swift
//  RecipesList
//
//  Created by Андрей Калямин on 30.07.2021.
//

import UIKit
import InjectPropertyWrapper

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, StoryboardInstantiable {
    
    @Inject private var viewModel: MainTabBarViewModel
    private var views: [UINavigationController]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    func setupViews(views: [UINavigationController]) {
        self.views = views
        viewModel.setupViews(views: self.views!)
        self.viewControllers = self.views
    }
    
    static func create() -> MainTabBarController {
        let view = MainTabBarController.instantiateViewController()
        return view
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

}
