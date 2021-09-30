//
//  MainTabView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

struct MainTabView: View {
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
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
