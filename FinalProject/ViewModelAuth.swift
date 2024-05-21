import Combine
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String?
    @Published var isAuthenticated: Bool = false
    @Published var currentUserUID: String?
    @Published var achievements: [Achievement] = []

    private var db = Firestore.firestore()
    
    init() {
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isAuthenticated = user != nil
            self.currentUserUID = user?.uid
            if let uid = user?.uid {
                self.fetchAchievements(for: uid)
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                self.isLoggedIn = true
                self.userEmail = email
                if let uid = authResult?.user.uid {
                    self.fetchAchievements(for: uid)
                }
                completion(nil)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                self.isLoggedIn = true
                self.userEmail = email
                if let uid = authResult?.user.uid {
                    self.addAchievement(uid: uid, achievement: Achievement(name: "Account Created")) { error in
                        if let error = error {
                            print("Error adding achievement: \(error)")
                        }
                    }
                }
                completion(nil)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.userEmail = nil
            self.achievements = []
        } catch {
            print("Sign out error: \(error)")
        }
    }

    func addAchievement(uid: String, achievement: Achievement, completion: @escaping (Error?) -> Void) {
        let achievementData: [String: Any] = [
            "name": achievement.name,
            "date": achievement.date
        ]
        db.collection("users").document(uid).collection("achievements").addDocument(data: achievementData) { error in
            if let error = error {
                completion(error)
            } else {
                self.fetchAchievements(for: uid)
                completion(nil)
            }
        }
    }

    func fetchAchievements(for uid: String) {
        db.collection("users").document(uid).collection("achievements").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching achievements: \(error)")
            } else {
                self.achievements = snapshot?.documents.compactMap { document -> Achievement? in
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    return Achievement(name: name, date: date)
                } ?? []
            }
        }
    }
}

struct Achievement: Identifiable {
    var id = UUID()
    var name: String
    var date: Date

    init(name: String, date: Date = Date()) {
        self.name = name
        self.date = date
    }
}


