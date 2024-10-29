//
//  APIService.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import Foundation
import Alamofire
import RxSwift

class APIService {
    
    var categoryList = BehaviorSubject<[Categories]>(value: [Categories]())
    var filteredMealList = BehaviorSubject<[FilteredMeals]>(value: [FilteredMeals]())
    
    func fetchCategories(completion: @escaping (Result<[Categories], Error>) -> Void) {
        let url = "https://www.themealdb.com/api/json/v1/1/categories.php"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    if let list = decodedResponse.categories {
                        self.categoryList.onNext(list)
                        completion(.success(list))
                    }
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func fetchMeals(byCategory category: String, completion: @escaping (Result<[FilteredMeals], Error>) -> Void) {
        let url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(FilteredMealsResponse.self, from: data)
                    if let list = decodedResponse.meals {
                        self.filteredMealList.onNext(list)
                        completion(.success(list))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
