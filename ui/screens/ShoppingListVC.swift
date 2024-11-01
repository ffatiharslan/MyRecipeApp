//
//  ShoppinListVC.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 1.11.2024.
//

import UIKit

class ShoppingListVC: UIViewController {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    private let firestoreService = FirestoreService()
    private let viewModel = ShoppingListViewModel()
    private var shoppingList: [(name: String, imageURL: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        _ = viewModel.shoppingList.subscribe(onNext: { list in
            self.shoppingList = list
            DispatchQueue.main.async {
                self.shoppingListTableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchShoppingList()
    }
    
}

extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListCell
        let ingredient = shoppingList[indexPath.row]
        
        cell.itemNameLabel.text = ingredient.name
        if let imageURL = URL(string: ingredient.imageURL) {
            cell.itemImageView.kf.setImage(with: imageURL)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let ingredient = shoppingList[indexPath.row]
        
        let ingredientData: [String: String] = ["ingredientName": ingredient.name, "ingredientImageURL": ingredient.imageURL]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.viewModel.removeIngredientFromShoppingList(ingredient: ingredientData) { result in
                switch result {
                case .success:
                    print("Malzeme başarıyla silindi")
                case .failure(let error):
                    print("Silme hatası: \(error.localizedDescription)")
                }
                completionHandler(true)
            }
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
