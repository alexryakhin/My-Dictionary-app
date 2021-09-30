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
    
    var body: some View {
        List {
            Section {
                Text("Fascinating")
                    .bold()
            } header: {
                Text("Given word")
            } footer: {
                Text("Choose from given definitions below")
            }
            
            Section {
                Text("definition 1")
                Text("definition 2")
                Text("definition 3")
            }

        }.navigationTitle("Choose Definition")
    }
}

struct ChooseDefinitionView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDefinitionView(vm: QuizzesViewModel())
    }
}
