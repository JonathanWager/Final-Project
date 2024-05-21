//
//  ContentView.swift
//  FinalProject
//
//  Created by Jonathan Wåger on 2024-03-12.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating = false
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                if isAnimating{
                    HomeView(authViewModel: authViewModel)
                }
                else{
                    SplashScreenView()
                        .transition(.opacity)
                }
            }
        }.task {
            withAnimation(Animation.easeInOut(duration: 4.0)) {
                isAnimating = true
            }
        }
    }
}

struct HomeView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var isDisclosed = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("images")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        .shadow(radius: 10)
                    
                    HStack {
                        Text("Se övningar")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            withAnimation {
                                isDisclosed.toggle()
                            }
                        }) {
                            Image(systemName: isDisclosed ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                                .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    
                    VStack {
                        GroupBox {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Övning 1")
                                Text("Övning 2")
                                Text("Övning 3")
                                Text("Övning 4")
                                Text("Övning 5")
                                Text("Övning 6")
                                Text("Övning 7")
                                Text("Övning 8")
                                Text("Övning 9")
                                Text("Övning 10")
                            }
                            .padding()
                        }
                        .frame(height: isDisclosed ? nil : 0, alignment: .top)
                        .clipped()
                        .animation(.easeInOut, value: isDisclosed)
                    }
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Start Workout")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitle("Meditera", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AboutView()) {
                        Text("Om Oss")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: LogInView(authViewModel: authViewModel)) {
                        Text(authViewModel.isLoggedIn ? "Account" : "Log In")
                            .foregroundColor(.white)
                    }
                }
            }

        }
    }
}


struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Om Oss")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            Spacer()
            
            Text("Välkommen till vår app! Vi är här för att hjälpa dig att hitta lugn och ro i din vardag. Med våra olika övningar och verktyg är vårt mål att ge dig verktyg för att koppla av, minska stress och främja ditt välbefinnande.")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .frame(width: 200, height: 600) // Justera bredden för att centrera texten på sidan
                .multilineTextAlignment(.center) // Centrera texten horisontellt
                
            Spacer()
        }
        .padding()
        .navigationBarTitle("Om Oss")
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}




struct SplashScreenView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.white
            Circle()
                .fill(Color.blue)
                .scaleEffect(scale)
                .frame(width: 100, height: 100)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2.0)) {
                        scale = 10.0
                    }
                }
        }
    }
}

struct AchievementView: View {
    var achievements: [Achievement]
    
    var body: some View {
        VStack {
            Text("Achievements")
                .font(.title)
                .padding()
            
            List(achievements) { achievement in
                VStack(alignment: .leading) {
                    Text(achievement.name)
                        .font(.headline)
                    Text("Date: \(achievement.date, formatter: dateFormatter)")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}


struct LogInView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignIn = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            if authViewModel.isLoggedIn {
                VStack {
                    Text("Välkommen, \(authViewModel.userEmail ?? "")")
                        .font(.title)
                        .padding()
                    
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Log Out")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    AchievementView(achievements: authViewModel.achievements)
                }
                .padding()
            } else {
                GeometryReader { proxy in
                    Color.blue
                    ScrollView {
                        VStack {
                            Spacer()
                            VStack {
                                TextField("Email", text: $email)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                
                                Button(action: {
                                    if isSignIn {
                                        signIn()
                                    } else {
                                        signUp()
                                    }
                                }) {
                                    Text(isSignIn ? "Sign In" : "Sign Up")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                
                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                
                                Toggle(isOn: $isSignIn) {
                                    Text(isSignIn ? "Don't have an account? Sign up" : "Already have an account? Log In")
                                        .foregroundColor(.blue)
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .padding()
                            
                           Spacer()
                        }
                        .ignoresSafeArea(.all, edges: .all)
                        .frame(minHeight: proxy.size.height)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                .ignoresSafeArea(.all, edges: .all)
                .navigationBarTitle("Sign In/Sign Up")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(Color.blue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .accentColor(.white)
            }
        }
    }

    func signUp() {
        authViewModel.signUp(email: email, password: password) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = nil
            }
        }
    }

    func signIn() {
        authViewModel.login(email: email, password: password) { error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = nil
            }
        }
    }
}




struct Exercise {
    let name: String
    let imageName: String
}

struct ExerciseView: View {
    @State private var currentExerciseIndex = 0
    @State private var timeRemaining = 600
    @State private var isResting = false
    @State private var isPaused = false
    @State private var timer: Timer?
    
    let exercises: [Exercise] = [
        Exercise(name: "övning1", imageName: "övning10"),
        Exercise(name: "övning2", imageName: "övning10"),
        Exercise(name: "övning3", imageName: "övning10"),
        Exercise(name: "övning4", imageName: "övning10"),
        Exercise(name: "övning5", imageName: "övning10"),
        Exercise(name: "övning6", imageName: "övning10"),
        Exercise(name: "övning7", imageName: "övning10"),
        Exercise(name: "övning8", imageName: "övning10"),
        Exercise(name: "övning9", imageName: "övning10"),
        Exercise(name: "övning10", imageName: "övning10")
    ]
    
    let exerciseDuration = 45 // 45 seconds per exercise
    let breakDuration = 15 // 15 seconds break
    
    var body: some View {
        VStack {
            Text("Time Remaining: \(timeString(time: timeRemaining))")
                .font(.largeTitle)
                .padding()
            
            if !isResting {
                ExerciseDetailView(exercise: exercises[currentExerciseIndex])
            } else {
                Text("Rest")
                    .font(.largeTitle)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                if self.isPaused {
                    self.startTimer()
                } else {
                    self.timer?.invalidate()
                }
                self.isPaused.toggle()
            }) {
                Text(isPaused ? "Resume" : "Pause")
                    .font(.title)
                    .padding()
                    .background(isPaused ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: startTimer)
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                if !self.isResting {
                    if self.timeRemaining % (self.exerciseDuration + self.breakDuration) == self.breakDuration {
                        self.isResting = true
                    }
                } else {
                    if self.timeRemaining % (self.exerciseDuration + self.breakDuration) == 0 {
                        self.isResting = false
                        self.currentExerciseIndex = (self.currentExerciseIndex + 1) % self.exercises.count
                    }
                }
            } else {
                timer.invalidate()
            }
        }
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack {
            Text(exercise.name)
                .font(.largeTitle)
                .padding()
            Image(exercise.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
}



#Preview {
    ContentView()
}
