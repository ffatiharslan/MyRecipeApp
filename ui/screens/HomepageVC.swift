//
//  ViewController.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 29.10.2024.
//

import UIKit
import Kingfisher
import FirebaseAuth

class HomepageVC: UIViewController {
    
    var categoryList = [Categories]()
    var filteredMealList = [FilteredMeals]()
    
    var viewModel = HomepageViewModel()
    
    var selectedCategoryIndex: Int = 0
    
    @IBOutlet weak var nameLabel: RPLabel!
    @IBOutlet weak var readyToCookLabel: RPLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var categoryLabel: RPLabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var mealsByCategoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCategoriesCollectionView()
        setupMealCollectionView()
        setupUserInfo()
        setupProfileImageViewTapGesture()
        
        _ = viewModel.categoryList.subscribe(onNext: { list in
                    self.categoryList = list
                    DispatchQueue.main.async {
                        self.categoriesCollectionView.reloadData()
                    
                        if let firstCategory = list.first {
                            self.fetchMeals(forCategory: firstCategory.strCategory ?? "")
                            self.selectedCategoryIndex = 0
                            self.categoriesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                        }
                    }
                })
        
        _ = viewModel.filteredMealList.subscribe(onNext: { list in
            self.filteredMealList = list
            DispatchQueue.main.async {
                self.mealsByCategoryCollectionView.reloadData()
            }
        })
    }
    
    
    func setupUserInfo() {
        if let firstName = UserDefaults.standard.string(forKey: "firstName") {
            nameLabel.text = "Hey, \(firstName)"
        }
        
        if let profileImageURLString = UserDefaults.standard.string(forKey: "profileImageURL"),
           let profileImageURL = URL(string: profileImageURLString) {
            profileImageView.kf.setImage(with: profileImageURL)
        }
    }
    
    
    private func setupProfileImageViewTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
            profileImageView.isUserInteractionEnabled = true
            profileImageView.addGestureRecognizer(tapGesture)
        }
        
        @objc private func profileImageTapped() {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let signOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
                self.signOutUser()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(signOutAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        private func signOutUser() {
            do {
                try Auth.auth().signOut()
                navigateToLoginScreen()
            } catch let signOutError as NSError {
                print("Çıkış yaparken hata oluştu: \(signOutError.localizedDescription)")
            }
        }
        
        private func navigateToLoginScreen() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginNavController")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = loginVC
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    
    private func setupCategoriesCollectionView() {
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 80)
        
        categoriesCollectionView.collectionViewLayout = layout
    }
    
    private func setupMealCollectionView() {
        mealsByCategoryCollectionView.delegate = self
        mealsByCategoryCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 30) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        mealsByCategoryCollectionView.collectionViewLayout = layout
    }
    
    private func configureUI() {
        nameLabel.configure(fontSize: 24, fontWeight: .bold, textColor: .label)
        nameLabel.text = "Hey, Fatih"
        readyToCookLabel.configure(fontSize: 17, fontWeight: .regular, textColor: .secondaryLabel)
        readyToCookLabel.text = "Ready to cook something?"
        profileImageView.layer.cornerRadius = 8
        categoryLabel.configure(fontSize: 24, fontWeight: .bold, textColor: .label)
        categoryLabel.text = "Categories"
    }
    
    private func fetchMeals(forCategory category: String) {
        viewModel.fetchMeals(byCategory: category) { result in
            switch result {
            case .success(let meals):
                self.filteredMealList = meals
                DispatchQueue.main.async {
                    self.mealsByCategoryCollectionView.reloadData()
                }
            case .failure(let error):
                print("Yemekler yüklenemedi: \(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealDetail",
           let destinationVC = segue.destination as? MealDetailVC,
           let selectedMealID = sender as? String {
            destinationVC.selectedMealID = selectedMealID
        }
    }
}


extension HomepageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categoryList.count
        } else {
            return filteredMealList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
            let category = categoryList[indexPath.row]
            if let imageURL = URL(string: category.strCategoryThumb!) {
                cell.categoryImageView.kf.setImage(with: imageURL)
            }
            cell.categoryLabel.text = category.strCategory
            
            cell.configure(selected: indexPath.row == selectedCategoryIndex)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealsByCategoryCell", for: indexPath) as! MealsByCategoryCell
            let meal = filteredMealList[indexPath.row]
            if let imageURL = URL(string: "\(meal.strMealThumb!)/preview") {
                cell.mealImageView.kf.setImage(with: imageURL)
            }
            cell.mealNameLabel.text = meal.strMeal
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            selectedCategoryIndex = indexPath.row
            categoriesCollectionView.reloadData()
            
            let selectedCategory = categoryList[indexPath.row].strCategory ?? ""
            fetchMeals(forCategory: selectedCategory)
        }
        
        else if collectionView == mealsByCategoryCollectionView {
            let selectedMeal = filteredMealList[indexPath.row]
            performSegue(withIdentifier: "toMealDetail", sender: selectedMeal.idMeal)
        }
    }
}
