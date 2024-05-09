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
                        
                        VStack {
                            Button("Börja"){}
                        }
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

#Preview {
    ContentView()
}
