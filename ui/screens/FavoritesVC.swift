//
//  FavoritesVC.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import UIKit
import Kingfisher

class FavoritesVC: UIViewController {
    
    let viewModel = FavoritesViewModel()
    var favorites = [FilteredMeals]()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        _ = viewModel.favoritesList.subscribe(onNext: { meals in
            self.favorites = meals
            self.favoritesTableView.reloadData()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavorites()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealDetailFromFavorites",
           let destinationVC = segue.destination as? MealDetailVC,
           let mealID = sender as? String {
            destinationVC.selectedMealID = mealID
        }
    }
}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        let meal = favorites[indexPath.row]
        cell.mealNameLabel.text = meal.strMeal
        if let imageURL = URL(string: meal.strMealThumb ?? "") {
            cell.imageView?.kf.setImage(with: imageURL)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = favorites[indexPath.row]
        performSegue(withIdentifier: "toMealDetailFromFavorites", sender: selectedMeal.idMeal)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            let meal = self.favorites[indexPath.row]
            self.viewModel.removeFavorite(mealID: meal.idMeal ?? "") { result in
                switch result {
                case .success:
                    self.favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("Favori silme hatası: \(error.localizedDescription)")
                }
            }
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
