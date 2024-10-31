//
//  LoginViewModel.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import Foundation
import UIKit

class LoginViewModel {
    
    private let authService = AuthService()
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signInWithGoogle(presentingVC: presentingVC, completion: completion)
    }
}


