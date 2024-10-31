//
//  FirestoreService.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 1.11.2024.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
    
    private let db = Firestore.firestore()
    
    // Favorilere yemek ekleme
    func addFavorite(meal: MealDetail, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış."])))
            return
        }
        
        let favoriteData: [String: Any] = [
            "idMeal": meal.idMeal ?? "",
            "strMeal": meal.strMeal ?? "",
            "strMealThumb": meal.strMealThumb ?? ""
        ]
        
        db.collection("favorites").document(userID).collection("userFavorites").document(meal.idMeal ?? "").setData(favoriteData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Favorilerden yemek kaldırma
    func removeFavorite(mealID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış."])))
            return
        }
        
        db.collection("favorites").document(userID).collection("userFavorites").document(mealID).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Favorileri çekme
    func fetchFavorites(completion: @escaping (Result<[FilteredMeals], Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış."])))
            return
        }
        
        db.collection("favorites").document(userID).collection("userFavorites").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var meals = [FilteredMeals]()
                for document in snapshot?.documents ?? [] {
                    if let meal = try? document.data(as: FilteredMeals.self) {
                        meals.append(meal)
                    }
                }
                completion(.success(meals))
            }
        }
    }
    
    // Bir yemeğin favori olup olmadığını kontrol etme
    func isFavorite(mealID: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        db.collection("favorites").document(userID).collection("userFavorites").document(mealID).getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
