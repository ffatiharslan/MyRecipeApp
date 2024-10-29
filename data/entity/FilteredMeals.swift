//
//  FilteredMeals.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import Foundation

class FilteredMeals: Codable {
    var strMeal: String?
    var strMealThumb: String?
    var idMeal: String?
    
    init(strMeal: String, strMealThumb: String, idMeal: String) {
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.idMeal = idMeal
    }
}
