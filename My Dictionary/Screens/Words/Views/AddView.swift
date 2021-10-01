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
                VStack(alignment: .leading, spacing: 11) {
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
                        .padding(.top, 11)
                    Divider().padding(.leading)
                    TextField("Word's definition", text: $descriptionField)
                        .padding(.horizontal)
                    Divider().padding(.leading)
                    TextField("Part of speech", text: $partOfSpeech)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .cornerRadius(10)
                    Divider().padding(.leading)
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
                        hideKeyboard()
                    }, label: {
                        Text("Get definitions from the Internet")
                            .padding(.vertical, 1)
                    })
                        .padding(.bottom, 11)
                        .foregroundColor(vm.inputWord.isEmpty ? Color.gray.opacity(0.5) : .green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .disabled(vm.inputWord.isEmpty)
                }
                .background(Color("TableBackground").cornerRadius(10))
                .padding(.horizontal)
                
                Section {
                    if vm.resultWordDetails != nil && vm.status == .ready {
                        WordCard(
                            wordMeanings: vm.resultWordDetails!.meanings, tapGesture: { descriptionStr, partOfSpeechStr in
                                descriptionField = descriptionStr
                                partOfSpeech = partOfSpeechStr
                            })
                    } else if vm.status == .loading {
                        VStack {
                            Spacer().frame(height: 50)
                            ProgressView()
                            Spacer()
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    } else if vm.status == .blank {
                        VStack {
                            Spacer().frame(height: 50)
                            Text("*After the data shows up here, tap on word's definition to fill it into definition's field")
                                .font(.caption)
                                .padding()
                            Spacer()
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    } else if vm.status == .error {
                        VStack {
                            Spacer().frame(height: 50)
                            Text("Couldn't get the word's data, check your spelling")
                                .bold()
                                .padding()
                            Spacer()
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                }
                
                .cornerRadius(15)
            }
            
            .ignoresSafeArea(.all, edges: [.bottom])
            .background(Color("Background")
                            .ignoresSafeArea()
                            .onTapGesture(perform: {
                hideKeyboard()
            })
            )
            .navigationBarTitle("Add new word")
            .navigationBarItems(trailing: Button(action: {
                if !vm.inputWord.isEmpty, !descriptionField.isEmpty {
                    let newWord = WordModel(word: vm.inputWord, description: descriptionField, partOfSpeech: partOfSpeech.isEmpty ? "unknown" : partOfSpeech, examples: [], wordElement: vm.resultWordDetails)
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


