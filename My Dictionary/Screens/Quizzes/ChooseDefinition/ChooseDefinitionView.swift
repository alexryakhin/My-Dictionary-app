//
//  ChooseDefinitionView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

struct ChooseDefinitionView: View {
    @ObservedObject var vm: QuizzesViewModel
    var rightAnswerIndex = Int.random(in: 0...2)
    @State private var isRightAnswer = true
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text(vm.words[rightAnswerIndex].word)
                        .bold()
                    Spacer()
                    Text(vm.words[rightAnswerIndex].partOfSpeech)
                        .foregroundColor(.secondary)
                }
                
            } header: {
                Text("Given word")
            } footer: {
                Text("Choose from given definitions below")
            }
            
            Section {
                ForEach(0..<3) { index in
                    Button {
                        if vm.words[rightAnswerIndex].id == vm.words[index].id {
                            withAnimation {
                                isRightAnswer = true
                                vm.words.shuffle()
                            }
                        } else {
                            withAnimation {
                                isRightAnswer = false
                            }
                        }
                    } label: {
                        Text(vm.words[index].description)
                            .foregroundColor(.primary)
                    }
                }
            } footer: {
                Text(isRightAnswer ? "" : "Incorrect. Try Arain")
            }

        }
        .navigationTitle("Choose Definition")
        .onAppear {
            vm.words.shuffle()
        }
    }
}

struct ChooseDefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDefinitionView(vm: QuizzesViewModel())
    }
}
