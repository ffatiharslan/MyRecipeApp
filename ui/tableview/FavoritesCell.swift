//
//  FavoritesCell.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
