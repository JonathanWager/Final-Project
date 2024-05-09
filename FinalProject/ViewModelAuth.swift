//
//  ViewModelAuth.swift
//  FinalProject
//
//  Created by Jonathan Wåger on 2024-05-09.
//

import SwiftUI
import Firebase
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUserUID: String?
    
    init() {
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isAuthenticated = user != nil
            self.currentUserUID = user?.uid
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { _, error in
            completion(error)
        })
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { _, error in
            completion(error)
        })
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        isAuthenticated = false
    }
}
