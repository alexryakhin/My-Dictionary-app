//
//  QuizesView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

struct QuizesView: View {
    @StateObject var vm = QuizzesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        SpellingQuizView(vm: vm)
                    } label: {
                        Text("Spelling")
                    }
                    
                    NavigationLink {
                        ChooseDefinitionView(vm: vm)
                    } label: {
                        Text("Choose the right definition")
                    }
                } footer: {
                    Text("All words are from your list.")
                }
            }
            .navigationTitle("Quizzes")
        }
        .onAppear {
            if vm.words.isEmpty {
                vm.getWords()
            }
        }
    }
}

struct QuizesView_Previews: PreviewProvider {
    static var previews: some View {
        QuizesView()
    }
}
