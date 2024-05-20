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
        NavigationStack{
            ZStack{
                VStack {
                    Image("images")
                    HStack{
                        Text("Se övningar")
                        Button("^") {
                            withAnimation {
                                isDisclosed.toggle()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    
                    VStack {
                        GroupBox {
                            Text("Övning 1")
                            Text("Övning 3")
                            Text("Övning 4")
                            Text("Övning 5")
                            Text("Övning 6")
                            Text("Övning 7")
                            Text("Övning 8")
                            Text("Övning 9")
                            Text("Övning 10")
                        }
                    }
                    .frame(height: isDisclosed ? nil : 0, alignment: .top)
                    .clipped()
                    
                    NavigationLink(destination: ExerciseView()) {
                                        Text("Start Workout")
                                            .font(.title)
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                }
                //.frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(
                Color.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitle("Meditera")
        }
         
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

struct LogInView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignIn = true
    @State private var errorMessage: String?
    @State private var readyToNavigate : Bool = false
    
    var body: some View {
        NavigationView {
                    GeometryReader{ proxy in
                        Color.orange
                        ScrollView{
                            VStack {
                                ZStack{
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 40)
                                        .frame(width: 260, height: 260, alignment: .center)
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 80)
                                        .frame(width: 260, height: 260, alignment: .center)
                                }
                                Spacer()
                                VStack{
                                    
                                    
                                    TextField("Email", text: $email)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    SecureField("Password", text: $password)
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
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                    
                                    if let errorMessage = errorMessage {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                    }
                                    
                                    Toggle(isOn: $isSignIn) {
                                        Text(isSignIn ? "Don't have an account? Sign up" : "Already have an account? Log In")
                                            .foregroundColor(.black)
                                    }
                                    .padding()
                                }
                                .background(Color.white)
                                ZStack{
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 40)
                                        .frame(width: 260, height: 260, alignment: .center)
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 80)
                                        .frame(width: 260, height: 260, alignment: .center)
                                }
                                
                            }
                            .ignoresSafeArea(.all, edges: .all)
                            .frame(minHeight: proxy.size.height)
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                    .ignoresSafeArea(.all, edges: .all)
                }
        .navigationBarTitle("Sign In/Sign Up")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(
            Color.white,
            for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationDestination(isPresented: $readyToNavigate){
            HomeView(authViewModel: authViewModel)
        }
        .onAppear {
            authViewModel.signOut()
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
                readyToNavigate = true
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
        Exercise(name: "Push-up", imageName: "pushup"),
        Exercise(name: "Squat", imageName: "squat"),
        Exercise(name: "Lunge", imageName: "lunge"),
        Exercise(name: "Plank", imageName: "plank"),
        Exercise(name: "Burpee", imageName: "burpee"),
        Exercise(name: "Sit-up", imageName: "situp"),
        Exercise(name: "Jumping Jack", imageName: "jumpingjack"),
        Exercise(name: "Mountain Climber", imageName: "mountainclimber"),
        Exercise(name: "High Knees", imageName: "highknees"),
        Exercise(name: "Leg Raise", imageName: "legraise")
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
