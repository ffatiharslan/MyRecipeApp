//
//  HomepageViewModel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import Foundation
import RxSwift

class HomepageViewModel {
    var apiService = APIService()
    
    var categoryList = BehaviorSubject<[Categories]>(value: [Categories]())
    var filteredMealList = BehaviorSubject<[FilteredMeals]>(value: [FilteredMeals]())
    
    init() {
        fetchCategories { _ in }
    }
    
    func fetchCategories(completion: @escaping (Result<[Categories], Error>) -> Void) {
        apiService.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categoryList.onNext(categories)
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchMeals(byCategory category: String, completion: @escaping (Result<[FilteredMeals], Error>) -> Void) {
        apiService.fetchMeals(byCategory: category) { result in
            switch result {
            case .success(let meals):
                self.filteredMealList.onNext(meals)
                completion(.success(meals))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
