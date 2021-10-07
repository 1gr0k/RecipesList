//
//  QRScanerViewModel.swift
//  RecipesList
//
//  Created by Андрей Калямин on 29.09.2021.
//

import Foundation
import SwinjectStoryboard
import SwiftUI
import InjectPropertyWrapper

public enum QRError: Error {
    case wrongQR
}

protocol QRScanerViewModelInput {
    func checkForInitString(string: String, completion: @escaping (Result<String, QRError>) -> Void)
    func creaateDetailViewController(id: String) -> RecipeDetailsViewController
    func creaateManualRecipeIdViewController(delegate: QRScanerDelegate) -> ManualEnterRecipeIdViewController
}

protocol QRScanerViewModelOutput {}

protocol QRScanerViewModel: QRScanerViewModelInput, QRScanerViewModelOutput {}

class DefaultQRScanerViewModel: QRScanerViewModel {
    
    let maskString = "recipeslist://recipe/"
    
    func checkForInitString(string: String, completion: @escaping (Result<String, QRError>) -> Void) {
        if let range: Range<String.Index> = string.range(of: maskString) {
            let index: Int = string.distance(from: string.startIndex, to: range.lowerBound)
            if index == 0 {
                let id = string.replacingOccurrences(of: maskString, with: "")
                completion(.success(id))
            }
        }
        else { completion(.failure(.wrongQR))}
    }
    
    func creaateDetailViewController(id: String) -> RecipeDetailsViewController {
        let storyboard = SwinjectStoryboard.create(name: "RecipeDetailsViewController", bundle: nil, container: AppDelegate.container)
        let vc = storyboard.instantiateInitialViewController()! as! RecipeDetailsViewController
        vc.setupId(id: id)
        return vc
    }
    
    func creaateManualRecipeIdViewController(delegate: QRScanerDelegate) -> ManualEnterRecipeIdViewController {
        let vc = AppDelegate.container.resolve(ManualEnterRecipeIdViewController.self, argument: delegate)!
        return vc
    }
    

}
