//
//  HomeView.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 6/20/21.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = Dictionary()
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.words.isEmpty {
                    ZStack {
                        Color("Background").ignoresSafeArea()
                        VStack {
                            Spacer().frame(height: 100)
                            Image(systemName: "applescript")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 60)
                            
                            Text("Begin to add words to your list\nby tapping on plus icon in upper left corner")
                                .padding(20)
                                .multilineTextAlignment(.center)
                                .lineSpacing(10)
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                    }
                } else {
                    List {
                        ForEach(vm.isFiltered ? vm.filteredWords : vm.words, id: \.id) { word in
                            NavigationLink(
                                destination: WordDetailView(vm: vm, wordData: word),
                                label: {
                                    HStack {
                                        Text("\(word.word)")
                                            .bold()
                                        Spacer()
                                        Text("\(word.partOfSpeech)")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                })
                        }
                        .onDelete(perform: removeItems)
                    }
                }
            }
            .navigationBarTitle("My Dictionary")
            .navigationBarItems(leading: Menu(content: {
                Menu {
                    Button {
                        vm.sort(by: .def)
                    } label: {
                        if vm.sortingState == .def {
                            Image(systemName: "checkmark")
                        }
                        Text("Default")
                    }
                    Button {
                        vm.sort(by: .name)
                    } label: {
                        if vm.sortingState == .name {
                            Image(systemName: "checkmark")
                        }
                        Text("Name")
                    }
                    Button {
                        vm.sort(by: .partOfSpeech)
                    } label: {
                        if vm.sortingState == .partOfSpeech {
                            Image(systemName: "checkmark")
                        }
                        Text("Part of speech")
                    }
                } label: {
                    Label {
                        Text("Sort By")
                    } icon: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                Menu {
                    Button {
                        vm.isFiltered = false
                        vm.filter(by: .none)
                    } label: {
                        if vm.filterState == .none {
                            Image(systemName: "checkmark")
                        }
                        Text("Off")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .noun)
                    } label: {
                        if vm.filterState == .noun {
                            Image(systemName: "checkmark")
                        }
                        Text("noun")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .verb)
                    } label: {
                        if vm.filterState == .verb {
                            Image(systemName: "checkmark")
                        }
                        Text("verb")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .adjective)
                    } label: {
                        if vm.filterState == .adjective {
                            Image(systemName: "checkmark")
                        }
                        Text("adjective")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .adverb)
                    } label: {
                        if vm.filterState == .adverb {
                            Image(systemName: "checkmark")
                        }
                        Text("adverb")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .exclamation)
                    } label: {
                        if vm.filterState == .exclamation {
                            Image(systemName: "checkmark")
                        }
                        Text("exclamation")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .conjunction)
                    } label: {
                        if vm.filterState == .conjunction {
                            Image(systemName: "checkmark")
                        }
                        Text("conjunction")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .pronoun)
                    } label: {
                        if vm.filterState == .pronoun {
                            Image(systemName: "checkmark")
                        }
                        Text("pronoun")
                    }
                    Button {
                        vm.isFiltered = true
                        vm.filter(by: .favorite)
                    } label: {
                        if vm.filterState == .favorite {
                            Image(systemName: "checkmark")
                        }
                        Text("favorite")
                    }
                } label: {
                    Label {
                        Text("Filter By")
                    } icon: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }, label: {
                Image(systemName: "ellipsis.circle")
            }), trailing: Button(action: {
                showingAddSheet = true
            }, label: {
                Image(systemName: "plus")
            })
            
            )
            .sheet(isPresented: $showingAddSheet) {
                AddView(vm: vm)
            }
        }
    }
    
    func removeItems(of offsets: IndexSet) {
        if !vm.isFiltered {
            vm.words.remove(atOffsets: offsets)
        } else {
            //remember id of word that i wanna delete
            let id = vm.filteredWords[offsets.first!].id
            //delete that word from temporary array
            vm.filteredWords.remove(atOffsets: offsets)
            //find this word in primary array and delete is as well
            if let wordIndex = vm.words.firstIndex(where: { $0.id == id }) {
                vm.words.remove(at: wordIndex)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
