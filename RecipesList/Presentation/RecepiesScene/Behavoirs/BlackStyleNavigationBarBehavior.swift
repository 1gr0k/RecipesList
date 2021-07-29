//
//  BlackStyleNavigationBarBehavior.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {
    
    func viewDidLoad(viewController: UIViewController) {
        viewController.navigationController?.navigationBar.barStyle = .black
    }
    
}
