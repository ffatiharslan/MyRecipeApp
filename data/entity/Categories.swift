//
//  Category.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import Foundation

class Categories: Codable {
    
    var idCategory: String?
    var strCategory: String?
    var strCategoryThumb: String?
    var strCategoryDescription: String?
    
    init(idCategory: String, strCategory: String, strCategoryThumb: String, strCategoryDescription: String) {
        self.idCategory = idCategory
        self.strCategory = strCategory
        self.strCategoryThumb = strCategoryThumb
        self.strCategoryDescription = strCategoryDescription
    }
}
