//
//  ShoppinListVC.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 1.11.2024.
//

import UIKit

class ShoppinListVC: UIViewController {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    private let firestoreService = FirestoreService()
    private var shoppingList: [(name: String, imageURL: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchShoppingList()
    }
    
    func fetchShoppingList() {
        firestoreService.fetchShoppingList { result in
            switch result {
            case .success(let ingredients):
                self.shoppingList = ingredients.map { ($0["ingredientName"] ?? "", $0["ingredientImageURL"] ?? "") }
                DispatchQueue.main.async {
                    self.shoppingListTableView.reloadData()
                }
            case .failure(let error):
                print("Alışveriş listesi alınamadı: \(error.localizedDescription)")
            }
        }
    }
}

extension ShoppinListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppinListCell
        let ingredient = shoppingList[indexPath.row]
        
        cell.itemNameLabel.text = ingredient.name
        if let imageURL = URL(string: ingredient.imageURL) {
            cell.itemImageView.kf.setImage(with: imageURL)
        }
        return cell
    }
}
