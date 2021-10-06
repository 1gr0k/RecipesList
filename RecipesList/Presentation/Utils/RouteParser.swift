//
//  RouteParser.swift
//  RecipesList
//
//  Created by Андрей Калямин on 06.10.2021.
//

import Foundation
import SwiftUI

let scheme = "recipeslist"

enum RouteParser {
    case recipe(String)
    case error
    
    var idString: String {
        switch self {
        case .recipe:
            return ""
        case .error:
            return ""
        }
    }
    
    init(route: String) {
        guard let url = URL(string: route), url.scheme == scheme else {self = .error; return }
        switch url.host {
        case "recipe":
            self = .recipe(url.lastPathComponent)
        default:
            self = .error
        }
    }
}
