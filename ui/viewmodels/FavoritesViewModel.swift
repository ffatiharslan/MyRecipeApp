//
//  FavoritesViewModel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 1.11.2024.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    private let firestoreService = FirestoreService()
    var favoritesList = BehaviorSubject<[FilteredMeals]>(value: [])
    
    func fetchFavorites() {
        firestoreService.fetchFavorites { result in
            switch result {
            case .success(let meals):
                self.favoritesList.onNext(meals)
            case .failure(let error):
                print("Favori yemekleri alma hatası: \(error)")
            }
        }
    }
}
