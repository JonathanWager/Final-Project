//
//  ContentView.swift
//  FinalProject
//
//  Created by Jonathan Wåger on 2024-03-12.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                if isAnimating{
                    HomeView()
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
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .padding()
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

#Preview {
    ContentView()
}
