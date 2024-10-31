//
//  MealDetailVC.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 30.10.2024.
//

import UIKit
import Kingfisher

class MealDetailVC: UIViewController {
    
    var viewModel = MealDetailViewModel()
    
    var selectedMealID: String?
    
    let firestoreService = FirestoreService()
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: RPLabel!
    @IBOutlet weak var segmentedBackView: UIView!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var ingrediantsCollectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
        
        ingrediantsCollectionView.delegate = self
        ingrediantsCollectionView.dataSource = self
        
        instructionsView.isHidden = false
        ingredientsView.isHidden = true
        
        guard let mealID = selectedMealID else {
            return
        }
        print(mealID)
        viewModel.fetchMealDetail(mealID: mealID) {
            self.configureUI()
            self.ingrediantsCollectionView.reloadData()
        }
    }
    
    func setupFavoriteButton() {
        firestoreService.isFavorite(mealID: selectedMealID!) { isFavorite in
            let imageName = isFavorite ? "heart.fill" : "heart"
            self.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let meal = viewModel.mealDetail else { return }
        
        firestoreService.isFavorite(mealID: meal.idMeal ?? "") { isFavorite in
            if isFavorite {
                self.firestoreService.removeFavorite(mealID: meal.idMeal ?? "") { result in
                    switch result {
                    case .success:
                        self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    case .failure(let error):
                        print("Favori silme hatası: \(error)")
                    }
                }
            } else {
                self.firestoreService.addFavorite(meal: meal) { result in
                    switch result {
                    case .success:
                        self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    case .failure(let error):
                        print("Favori ekleme hatası: \(error)")
                    }
                }
            }
        }
    }
    
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            instructionsView.isHidden = false
            ingredientsView.isHidden = true
        case 1:
            instructionsView.isHidden = true
            ingredientsView.isHidden = false
        default:
            break
        }
    }
    
    
    
    func configureUI() {
        mealNameLabel.configure(fontSize: 28, fontWeight: .bold, textColor: .label)
        mealNameLabel.text = viewModel.mealDetail?.strMeal
        instructionsLabel.text = viewModel.getInstructions()
        if let imageURL = viewModel.getMealImageURL() {
            mealImageView.kf.setImage(with: imageURL)
        }
        segmentedBackView.layer.cornerRadius = 20
        
        
    }
    
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 40) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        ingrediantsCollectionView.collectionViewLayout = layout
    }
}


extension MealDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getIngredients().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngrediantsCell", for: indexPath) as! IngrediantsCell
        let ingredient = viewModel.getIngredients()[indexPath.row]
        cell.ingrediantNameLabel.text = ingredient.0
        cell.ingrediantMeasureLabel.text = ingredient.1
        
        if let imageURL = URL(string: "https://www.themealdb.com/images/ingredients/\(ingredient.0)-Small.png") {
            cell.ingrediantImageView.kf.setImage(with: imageURL)
        }
        
        return cell
    }
}
