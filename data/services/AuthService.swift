//
//  AuthService.swift
//  MyRecipeApp
//
//  Created by fatih arslan on 31.10.2024.
//

import Firebase
import GoogleSignIn
import UIKit
import FirebaseAuth

class AuthService {
    
    func signInWithGoogle(presentingVC: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID bulunamadı."])))
            return
        }
        
        _ = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "GoogleAuth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Authentication bilgisi alınamadı."])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // Kullanıcının adını ve profil fotoğrafı URL'sini alıyoruz
                    let firstName = user.profile?.givenName
                    let profileImageURL = user.profile?.imageURL(withDimension: 200)?.absoluteString
                    
                    if let firstName = firstName, let profileImageURL = profileImageURL {
                        UserDefaults.standard.set(firstName, forKey: "firstName")
                        UserDefaults.standard.set(profileImageURL, forKey: "profileImageURL")
                    }
                    
                    completion(.success(()))
                }
            }
        }
    }
}
