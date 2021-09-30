//
//  SpellingQuizView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

struct SpellingQuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: QuizzesViewModel
    @State private var randomWord: WordModel?
    @State private var answerTextField = ""
    @State private var isRightAnswer = true
    @State private var isShowAlert = false
    @State private var attemptCount = 0
    
    var body: some View {
        List {
            Section {
                Text(randomWord?.description ?? "Error")
            } header: {
                Text("Definition")
            } footer: {
                Text("Guess the word and then spell it correctly in a text field below")
            }

            Section {
                HStack {
                    TextField("Type here", text: $answerTextField, onCommit:  {
                        withAnimation {
                            checkAnswer()
                        }
                    })
                    Spacer()
                    Text(randomWord?.partOfSpeech ?? "error").foregroundColor(.secondary)
                }
            } footer: {
                Text(isRightAnswer ? "" : incorrectMessage)
            }
            
            Section {
                Button {
                    withAnimation {
                        checkAnswer()
                    }
                } label: {
                    Text("Confirm answer")
                }.disabled(answerTextField.isEmpty)

            }
        }
        .navigationTitle("Spelling")
        .onAppear {
            randomWord = vm.words.randomElement()
        }
        .onDisappear(perform: {
            vm.getWords()
        })
        .alert(isPresented: $isShowAlert, content: {
            Alert(title: Text("Congratulations"), message: Text("You got all your words!"), dismissButton: .default(Text("Okay"), action: {
                presentationMode.wrappedValue.dismiss()
            }))
        })
    }
    
    var incorrectMessage: String {
        guard let randomWord = randomWord else {
            return ""
        }
        
        if attemptCount > 2 {
            return "Your word is '\(randomWord.word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))'. Try harder :)"
        } else {
            return "Incorrect. Try again"
        }
    }
    
    private func checkAnswer() {
        guard let randomWord = randomWord else {
            return
        }
        
        guard let wordIndex = vm.words.firstIndex(where: {
            $0.id == randomWord.id
        }) else {
            return
        }
        
        if answerTextField.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == randomWord.word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            isRightAnswer = true
            answerTextField = ""
            vm.words.remove(at: wordIndex)
            attemptCount = 0
            if !vm.words.isEmpty {
                self.randomWord = vm.words.randomElement()
            } else {
                isShowAlert = true
            }
            
        } else {
            isRightAnswer = false
            attemptCount += 1
        }
    }
}

struct SpellingQuizView_Previews: PreviewProvider {
    static var previews: some View {
        SpellingQuizView(vm: QuizzesViewModel())
    }
}
