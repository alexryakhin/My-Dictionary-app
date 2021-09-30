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
    @State private var showingOnboarding = false
    
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
            .navigationBarItems(leading: Button(action: {
                showingOnboarding = true
            }, label: {
                Image(systemName: "hand.raised")
            }), trailing: Button(action: {
                showingAddSheet = true
            }, label: {
                Image(systemName: "plus")
            })
            
            )
            .sheet(isPresented: $showingAddSheet) {
                AddView(vm: vm)
            }
            .sheet(isPresented: $showingOnboarding) {
                OnboardingView()
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
