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
                            ScrollView { // Wrap the VStack with ScrollView
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Övning 1")
                                    Text("""
                                        Mountain Pose (Tadasana): Stå upp med fötterna ihop eller lätt isär, sträck armarna ner längs sidorna med handflatorna vända mot kroppen. Rulla axlarna tillbaka och ner, stå rak i ryggen och fokusera på djupandning. Denna övning främjar stabilitet och närvaro.
                                        """)
                                    Text("Övning 2")
                                    Text("""
                                        Barnets position (Balasana): Sitt på knäna med stortårna ihop och knäna isär. Luta dig framåt och sträck armarna framåt mot golvet med pannan vilar mot mattan. Andas djupt och slappna av i ryggen och nacken.
                                        """)
                                    Text("Övning 3")
                                    Text("""
                                        Katt-Ko-pose (Marjaryasana-Bitilasana): Kom ner på alla fyra med händerna under axlarna och knäna under höfterna. Inandas, sänk magen mot mattan och lyft huvudet och svansen uppåt för Ko-pose. Andas ut, rund ryggen och dra hakan mot bröstet för Katt-pose.
                                        """)
                                    Text("Övning 4")
                                    Text("""
                                        Sittande framåtböjning (Paschimottanasana): Sitt på golvet med benen utsträckta framåt. Andas in, sträck armarna uppåt, och andas ut, böj framåt från höfterna och sträck armarna mot tårna. Håll ryggen rak och slappna av i nacken.
                                        """)
                                    Text("Övning 5")
                                    Text("""
                                        Ben-upp-vid-väggen-position (Viparita Karani): Ligg på ryggen intill en vägg och lyft benen rakt upp mot taket med rumpan nära väggen. Placera armarna bredvid kroppen med handflatorna uppåt och slappna av i nacken och axlarna.
                                        """)
                                    Text("Övning 6")
                                    Text("""
                                        Död mans position (Savasana): Ligg på ryggen med benen något isär och armarna längs sidorna med handflatorna uppåt. Slappna av helt i kroppen och fokusera på djupandning.
                                        """)
                                    Text("Övning 7")
                                    Text("""
                                        Sittande ryggtvist (Ardha Matsyendrasana): Sitt på golvet med benen utsträckta framåt. Böj det högra benet och placera foten utanför det vänstra låret. Sväng överkroppen mot höger och placera vänster arm på utsidan av det högra knät med höger hand bakom dig för stöd. Andas in för att förlänga ryggraden och andas ut för att fördjupa twisten.
                                        """)
                                    Text("Övning 8")
                                    Text("""
                                        Stående framåtböjning (Uttanasana): Stå upp med fötterna tätt ihop eller lätt isär. Andas in, sträck armarna uppåt, och andas ut, böj framåt från höfterna och sträck armarna mot golvet eller benen. Slappna av i nacken och låt huvudet hänga fritt.
                                        """)
                                    Text("Övning 9")
                                    Text("""
                                        Liggande fjärilsposition (Supta Baddha Konasana): Ligg på ryggen med knäna böjda och fötterna nära rumpan. Låt knäna falla utåt mot sidorna och placera fotsulorna mot varandra. Placera händerna på magen eller längs sidorna och slappna av i höfterna och ljumskarna.
                                        """)
                                    Text("Övning 10")
                                    Text("""
                                        Sittande meditation med knäna ihop (Sukhasana eller Lotusposition):
                                        Sitt på en kudde eller en matta med benen korsade, och placera varje fot på motsatt lår så att knäna ligger ner mot marken.
                                        Placera händerna på knäna med handflatorna vända uppåt och tummarna och pekfingrarna möts i Gyan Mudra, eller bara vila händerna i knäet.
                                        Håll ryggraden rak men avslappnad, och låt axlarna sjunka neråt från öronen.
                                        Släpp spänningar i ansikte, käkar och nacke, och låt ögonen vara slutna eller halvöppna med en mjuk blick riktad mot marken framför dig.
                                        Fokusera på din andning, låt den vara naturlig och obegränsad. Observera känslan av att andas in och ut, utan att ändra på något sätt.
                                        När tankar, känslor eller sinnesintryck kommer upp, observera dem utan att döma eller fastna i dem. Låt dem komma och gå som moln på himlen, och återvänd sedan till din andning.

                                        """)
                                }
                                .padding()
                            }
                        }
                        .frame(height: isDisclosed ? nil : 0, alignment: .top)
                        .clipped()
                        .animation(.easeInOut, value: isDisclosed)
                    }
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Slappna Av")
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
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Sign In/Sign Up")
                                .font(.largeTitle)
                                .foregroundColor(.blue) // Set the text color here
                        }
                    }
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color.white, for: .navigationBar)
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
    var id = UUID()
    let name: String
    let imageName: String
}

struct ExerciseView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    @State private var currentExerciseIndex = 0
    @State private var timeRemaining = 600
    @State private var isResting = false
    @State private var isPaused = false
    @State private var timer: Timer?
    
    let exercises: [Exercise] = [
        Exercise(name: "Mountain Pose", imageName: "mountain_pose"),
        Exercise(name: "Child's Pose", imageName: "childspose"),
        Exercise(name: "Cat-Cow Pose", imageName: "cat"),
        Exercise(name: "Seated Forward Bend", imageName: "23-seatedforward"),
        Exercise(name: "Legs-Up-the-Wall Pose", imageName: "Legs-Up-the-Wall-Pose-restorative"),
        Exercise(name: "Corpse Pose", imageName: "13-corpse-pose"),
        Exercise(name: "Seated Spinal Twist", imageName: "18-halflord-fishes"),
        Exercise(name: "Standing Forward Bend", imageName: "standing-forward-bend"),
        Exercise(name: "Reclining Bound Angle Pose", imageName: "10-reclining-bound-angle"),
        Exercise(name: "Meditation", imageName: "images 1")
    ]
    
    let exerciseDuration = 45// 45 seconds per exercise
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
                    .background(isPaused ? Color.blue : Color.cyan)
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
                        
                        if self.currentExerciseIndex == 0 {
                            self.authViewModel.incrementWorkoutCount() // Increment workout count after completing all exercises
                        }
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
