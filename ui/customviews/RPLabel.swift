//
//  RPLabel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import UIKit

class RPLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    
    private func setupLabel() {
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.7
    }
    
    
    func configure(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor) {
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = textColor
    }
}
