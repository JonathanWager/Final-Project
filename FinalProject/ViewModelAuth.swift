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
    @Published var workoutCount: Int = 0 // New variable to track workout count

    private var db = Firestore.firestore()
    
    init() {
        Auth.auth().addStateDidChangeListener { (_, user) in
            self.isAuthenticated = user != nil
            self.currentUserUID = user?.uid
            if let uid = user?.uid {
                self.fetchAchievements(for: uid)
                self.fetchWorkoutCount(for: uid) // Fetch workout count on initialization
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
                    self.fetchWorkoutCount(for: uid) // Fetch workout count on login
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
                    // Create workoutCount for the new user
                    self.createWorkoutCount(for: uid)
                    
                    // Add achievement for account created
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

    private func createWorkoutCount(for uid: String) {
        db.collection("users").document(uid).setData(["workoutCount": 0]) { error in
            if let error = error {
                print("Error creating workoutCount for user: \(error)")
            } else {
                print("Workout count created for user")
            }
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.userEmail = nil
            self.achievements = []
            self.workoutCount = 0 // Reset workout count on sign out
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

    func fetchWorkoutCount(for uid: String) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.workoutCount = document.data()?["workoutCount"] as? Int ?? 0
            } else {
                print("Document does not exist")
            }
        }
    }

    func incrementWorkoutCount() {
        guard let uid = self.currentUserUID else { return }
        self.workoutCount += 1
        db.collection("users").document(uid).updateData(["workoutCount": self.workoutCount]) { error in
            if let error = error {
                print("Error updating workout count: \(error)")
            } else {
                self.checkAchievements(for: uid)
            }
        }
    }

    func checkAchievements(for uid: String) {
        switch self.workoutCount {
        case 1:
            self.addAchievement(uid: uid, achievement: Achievement(name: "First Workout")) { _ in }
        case 5:
            self.addAchievement(uid: uid, achievement: Achievement(name: "Fifth Workout")) { _ in }
        case 10:
            self.addAchievement(uid: uid, achievement: Achievement(name: "Tenth Workout")) { _ in }
        default:
            break
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



