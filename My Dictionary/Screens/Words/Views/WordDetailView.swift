//
//  WordDetailView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/28/21.
//

import SwiftUI

struct WordDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: Dictionary
    var wordData: WordModel
    @State private var isEditingDefinition = false
    @State private var isShowAddExample = false
    @State private var exampleTextFieldStr = ""
    @State private var examples = [String]()
    
    var body: some View {
        
        
        List {
            Section {
                Text(wordData.partOfSpeech)
            } header: {
                Text("Part Of Speech")
            }
            Section {
                Text(wordData.description)
                    .contextMenu {
                        Button("Edit", action: {
                            isEditingDefinition = true
                        })
                    }
            } header: {
                Text("Definition")
            }
            Section {
                
                Button {
                    withAnimation {
                        isShowAddExample = true
                    }
                } label: {
                    Text("Add example")
                }
                if !examples.isEmpty {
                    ForEach(examples, id: \.self) { text in
                        Text(text)
                    }.onDelete(perform: removeExamples)
                }
                if isShowAddExample {
                    TextField("Type an example here", text: $exampleTextFieldStr, onCommit: {
                        withAnimation(.easeInOut) {
                            //save
                            isShowAddExample = false
                            if let wordIndex = wordIndex, exampleTextFieldStr != "" {
                                examples.append(exampleTextFieldStr)
                                vm.words[wordIndex].examples = examples
                            }
                            exampleTextFieldStr = ""
                        }
                    })
                }
            } header: {
                Text("Examples")
            }
            
            
        }
        .navigationTitle(wordData.word)
        .navigationBarItems(trailing: Button(action: {
            //delete
            presentationMode.wrappedValue.dismiss()
            removeWord()
        }, label: {
            Image(systemName: "trash").foregroundColor(.red)
        }))
        .sheet(isPresented: $isEditingDefinition) {
            let bindingWordDefinition = Binding (
                get: { wordData.description },
                set: {
                    if let wordIndex = wordIndex {
                        vm.words[wordIndex].description = $0
                    }
                }
            )
            TextEditor(text: bindingWordDefinition)
                .padding()
        }
        .onAppear {
            if let wordIndex = wordIndex {
                examples = vm.words[wordIndex].examples
            }
        }
    }
    
    private var wordIndex: Array<WordModel>.Index? {
        if let wordIndex = vm.words.firstIndex(where: {
            $0.id == wordData.id
        }) {
            return wordIndex
        }
        return nil
    }
    
    private func removeWord() {
        if let wordIndex = wordIndex {
            vm.words.remove(at: wordIndex)
        }
    }
    
    private func removeExamples(of offsets: IndexSet) {
        examples.remove(atOffsets: offsets)
        
        if let wordIndex = wordIndex {
            vm.words[wordIndex].examples = examples
        }
    }
    
    
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailView(vm: Dictionary(), wordData: WordModel.wordExample)
    }
}
