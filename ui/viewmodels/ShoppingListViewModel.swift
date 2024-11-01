//
//  ShoppingListViewModel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 1.11.2024.
//

import Foundation
import RxSwift

class ShoppingListViewModel {
    private let firestoreService = FirestoreService()
    var shoppingList = BehaviorSubject<[(name: String, imageURL: String)]>(value: [])
    
    func fetchShoppingList() {
        firestoreService.fetchShoppingList { [weak self] result in
            switch result {
            case .success(let ingredients):
                let list = ingredients.map { ($0["ingredientName"] ?? "", $0["ingredientImageURL"] ?? "") }
                self?.shoppingList.onNext(list)
            case .failure(let error):
                print("cannot get shopping list: \(error.localizedDescription)")
            }
        }
    }
    
    func removeIngredientFromShoppingList(ingredient: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreService.removeIngredientFromShoppingList(ingredient: ingredient) { [weak self] result in
            switch result {
            case .success:
                self?.fetchShoppingList()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

