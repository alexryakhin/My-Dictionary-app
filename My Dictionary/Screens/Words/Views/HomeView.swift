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
                List {
                    ForEach(vm.words, id: \.id) { word in
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
                    }.onDelete(perform: removeItems)
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
                        //
                    } label: {
                        Text("noun")
                    }
                    Button {
                        //
                    } label: {
                        Text("verb")
                    }
                    Button {
                        //
                    } label: {
                        Text("adjective")
                    }
                    Button {
                        //
                    } label: {
                        Text("adverb")
                    }
                    Button {
                        //
                    } label: {
                        Text("exclamation")
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
        vm.words.remove(atOffsets: offsets)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
