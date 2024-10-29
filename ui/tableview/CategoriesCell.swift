//
//  CategoriesCellCollectionViewCell.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: RPLabel!
    
    func configure(selected: Bool) {
        contentView.backgroundColor = selected ? UIColor(named: "selectedCategoryColor") : .clear
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
}
