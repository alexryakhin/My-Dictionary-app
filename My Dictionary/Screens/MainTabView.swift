//
//  MainTabView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

struct MainTabView: View {
    @State private var showingOnboarding: Bool = !CurrentUser.shared.hasSeenOnboarding
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Words", systemImage: "textformat.abc")
            }
            QuizesView()
                .tabItem {
                    Label("Quiz", systemImage: "a.magnify")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingOnboarding, onDismiss: {
            CurrentUser.shared.hasSeenOnboarding = true
        }) {
            OnboardingView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
