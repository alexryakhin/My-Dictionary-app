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
        let bindingWordDefinition = Binding (
            get: { vm.words[wordIndex ?? 0].description },
            set: {
                if let wordIndex = wordIndex {
                    vm.words[wordIndex].description = $0
                }
            }
        )
        
        List {
            if wordData.wordElement != nil {
                Section {
                    HStack {
                        Text("[\(wordData.wordElement?.phonetic ?? "No transcription")]")
                        Spacer()
                        Button {
                            AudioManager.shared.playback(phonetics: wordData.wordElement!.phonetics)
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                        }
                    }
                } header: {
                    Text("Phonetics")
                }
            }
            Section {
                Text(wordData.partOfSpeech)
                    .contextMenu {
                        ForEach(PartOfSpeech.allCases, id: \.self) { c in
                            Button {
                                if let wordIndex = wordIndex {
                                    vm.words[wordIndex].partOfSpeech = c.rawValue
                                }
                            } label: {
                                Text(c.rawValue)
                            }
                        }
                    }
            } header: {
                Text("Part Of Speech")
            }
            Section {
                if isEditingDefinition {
                    TextField("Definition", text: bindingWordDefinition, onCommit:  {
                        withAnimation {
                            isEditingDefinition = false
                        }
                    })
                } else {
                    Text(wordData.description)
                        .contextMenu {
                            Button("Edit", action: {
                                withAnimation {
                                    isEditingDefinition = true
                                }
                            })
                        }
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
        .navigationBarItems(leading: Button(action: {
            //favorites
            if let wordIndex = wordIndex {
                if vm.words[wordIndex].isFavorite {
                    vm.words[wordIndex].isFavorite = false
                } else {
                    vm.words[wordIndex].isFavorite = true
                }
            }
        }, label: {
            Group {
                if let wordIndex = wordIndex {
                    Image(systemName: "\(vm.words[wordIndex].isFavorite ? "heart.fill" : "heart")")
                }
            }
        }),
           trailing: Button(action: {
            //delete
            removeWord()
        }, label: {
            Image(systemName: "trash")
                .foregroundColor(vm.words.count <= 1 ? .secondary : .red)
        }).disabled(vm.words.count <= 1))
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
        if let wordIndex = wordIndex, vm.words.count > 1 {
            presentationMode.wrappedValue.dismiss()
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
