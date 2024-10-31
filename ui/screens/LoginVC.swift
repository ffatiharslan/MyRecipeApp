//
//  LoginVC.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import UIKit

class LoginVC: UIViewController {

   var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func googleSingInButton(_ sender: UIButton) {
        viewModel.signInWithGoogle(presentingVC: self) { result in
            switch result {
            case .success:
                self.navigateToMainScreen()
                
            case .failure(let error):
                self.showAlert(message: "Giriş hatası: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
       
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = mainTabBarController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
