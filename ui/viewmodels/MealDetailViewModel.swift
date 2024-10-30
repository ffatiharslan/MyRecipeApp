//
//  MealDetailViewModel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import Foundation

class MealDetailViewModel {
    
    private let apiService = APIService()
    var mealDetail: MealDetail?
    
    func fetchMealDetail(mealID: String, completion: @escaping () -> Void) {
        apiService.fetchMealDetail(by: mealID) { result in
            switch result {
            case .success(let meal):
                self.mealDetail = meal
                completion()
            case .failure(let error):
                print("Error fetching meal detail: \(error)")
            }
        }
    }
    
    
    func getIngredients() -> [(String, String)] {
        guard let meal = mealDetail else { return [] }
        
        var ingredients: [(String, String)] = []
        
        if let ingredient = meal.strIngredient1, let measure = meal.strMeasure1, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient2, let measure = meal.strMeasure2, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient3, let measure = meal.strMeasure3, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient4, let measure = meal.strMeasure4, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient5, let measure = meal.strMeasure5, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient6, let measure = meal.strMeasure6, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient7, let measure = meal.strMeasure7, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient8, let measure = meal.strMeasure8, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient9, let measure = meal.strMeasure9, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        if let ingredient = meal.strIngredient10, let measure = meal.strMeasure10, !ingredient.isEmpty {
            ingredients.append((ingredient, measure))
        }
        
        return ingredients
    }
    
    
    func getInstructions() -> String {
        return mealDetail?.strInstructions ?? ""
    }
    
    func getMealImageURL() -> URL? {
        guard let urlString = mealDetail?.strMealThumb else { return nil }
        return URL(string: urlString)
    }
    
}

