//
//  AddView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 6/20/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm: Dictionary
    @State private var descriptionField = ""
    @State private var partOfSpeech = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    TextField("Enter your word", text: $vm.inputWord, onCommit: {
                        if !vm.inputWord.isEmpty {
                            if vm.definitions.isEmpty {
                                vm.fetchData()
                            } else {
                                vm.definitions.removeAll()
                                vm.fetchData()
                            }
                        } else {
                            print("type a word")
                        }
                    })
                        .padding(.horizontal)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                    TextField("Word's definition", text: $descriptionField)
                        .padding(.horizontal)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    TextField("Part of speech", text: $partOfSpeech)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    Button(action: {
                        if !vm.inputWord.isEmpty {
                            if vm.definitions.isEmpty {
                                vm.fetchData()
                            } else {
                                vm.definitions.removeAll()
                                vm.fetchData()
                            }
                        } else {
                            print("type a word")
                        }
                    }, label: {
                        Text("Get definitions from the Internet")
                            .bold()
                    })
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Section {
                    if vm.resultWordDetails != nil && vm.status == .ready {
                        WordCard(
                            wordMeanings: vm.resultWordDetails!.meanings, tapGesture: { descriptionStr, partOfSpeechStr in
                                descriptionField = descriptionStr
                                partOfSpeech = partOfSpeechStr
                            })
                    } else if vm.status == .loading {
                        Spacer().frame(height: 50)
                        ProgressView()
                        Spacer()
                    } else if vm.status == .blank {
                        Spacer().frame(height: 50)
                        Text("*After the data shows up here, tap on word's definition to fill it into definition's field")
                            .font(.caption)
                            .padding()
                        Spacer()
                    } else if vm.status == .error {
                        Spacer().frame(height: 50)
                        Text("Couldn't get the word's data, check your spelling")
                            .bold()
                            .padding()
                        Spacer()
                    }
                }
                
                .cornerRadius(15)
            }
            
            .ignoresSafeArea(.all, edges: [.bottom])
            .background(Color.blue.opacity(0.2).ignoresSafeArea())
            .navigationBarTitle("Add new word")
            .navigationBarItems(trailing: Button(action: {
                if !vm.inputWord.isEmpty, !descriptionField.isEmpty {
                    let newWord = WordModel(word: vm.inputWord, description: descriptionField, partOfSpeech: partOfSpeech, examples: [], wordElement: vm.resultWordDetails)
                    vm.words.append(newWord)
                    self.presentationMode.wrappedValue.dismiss()
                    vm.resultWordDetails = nil
                    vm.inputWord = ""
                    vm.status = .blank
                } else {
                    showingAlert = true
                }
            }, label: {
                Text("Save")
            }))
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Error"), message: Text("You should enter a word and its description before saving it"), dismissButton: .default(Text("Got it")))
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(vm: Dictionary())
    }
}


