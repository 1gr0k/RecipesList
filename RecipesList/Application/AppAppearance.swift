//
//  AppAppearance.swift
//  RecipesList
//
//  Created by Андрей Калямин on 16.07.2021.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = .white
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
