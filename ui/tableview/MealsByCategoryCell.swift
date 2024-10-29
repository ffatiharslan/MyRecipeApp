//
//  ProductsByCategoryCell.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import UIKit

class MealsByCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.backgroundColor = UIColor(named: "backViewColor")
        backView.layer.cornerRadius = 12
        backView.layer.masksToBounds = true
        
        mealImageView.layer.cornerRadius = 20
        mealImageView.clipsToBounds = true
    }
}
