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
}
