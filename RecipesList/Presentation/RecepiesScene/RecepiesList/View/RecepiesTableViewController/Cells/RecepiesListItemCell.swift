//
//  RecepiesListItemCell.swift
//  RecipesList
//
//  Created by Андрей Калямин on 19.07.2021.
//

import UIKit

final class RecepiesListItemCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    static let reuseIdentifier = String(describing: RecepiesListItemCell.self)
    static let height = CGFloat(300)
    
    private var viewModel: RecepiesListItemViewModel!
    
    func fill(with viewModel: RecepiesListItemViewModel) {
        self.viewModel = viewModel
        
        idLabel.text = viewModel.title
    }
}
