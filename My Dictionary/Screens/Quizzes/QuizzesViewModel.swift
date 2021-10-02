//
//  QuizzesViewModel.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 9/30/21.
//

import SwiftUI

class QuizzesViewModel: ObservableObject {
    
    @Published var words: [WordModel] = []
    @Published var spellQuizWords: [WordModel] = []
    
    func getWords() {
        let fileName = getDocumentsDirectory().appendingPathComponent("words")

        do {
            let words = try Data(contentsOf: fileName)
            self.words = try JSONDecoder().decode([WordModel].self, from: words)
            self.spellQuizWords = try JSONDecoder().decode([WordModel].self, from: words)
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
