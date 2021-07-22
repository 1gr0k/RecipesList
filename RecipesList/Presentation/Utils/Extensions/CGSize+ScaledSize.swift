//
//  CGSize+ScaledSize.swift
//  RecipesList
//
//  Created by Андрей Калямин on 21.07.2021.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
