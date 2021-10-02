//
//  DictionaryViewModel.swift
//  My Dictionary
//
//  Created by Alexander Bonney on 6/20/21.
//

import Foundation
import SwiftUI

class Dictionary: ObservableObject {
    
    @Published var status: FetchingStatus = .blank
    @Published var inputWord: String = ""
    @Published var resultWordDetails: WordElement?
    @Published var sortingState: SortingCases = .def
    @Published var filterState: FilterCases = .none
    @Published var filteredWords: [WordModel] = []
    @Published var isFiltered: Bool = false
    @Published var definitions: [String] = []
    @Published var words: [WordModel] = [] {
        didSet {
            save()
            filter(by: filterState)
        }
    }
    
    init() {
        getWords()
    }
        
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fetchData() {
        status = .loading
        if inputWord != "" {
            let stringURL = "https://api.dictionaryapi.dev/api/v2/entries/en/\(inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))"
            guard let url = URL(string: stringURL) else {
                DispatchQueue.main.async {
                    self.status = .error
                }
                return
            }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.status = .error
                    }
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(Words.self, from: data)
                    DispatchQueue.main.async {
                        self.resultWordDetails = decodedData.first!
                        self.status = .ready
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        self.resultWordDetails = nil
                        self.status = .error
                    }
                    print(error.localizedDescription)
                }
            }.resume()
        } else {
            return
        }
    }
    
    func sort(by what: SortingCases) {
        DispatchQueue.main.async {
            withAnimation() {
                switch what {
                case .def:
                    self.sortingState = .def
                    self.words.sort {
                        $0.date < $1.date
                    }
                    self.filteredWords.sort {
                        $0.date < $1.date
                    }
                case .name:
                    self.sortingState = .name
                    self.words.sort {
                        $0.word < $1.word
                    }
                    self.filteredWords.sort {
                        $0.word < $1.word
                    }
                case .partOfSpeech:
                    self.sortingState = .partOfSpeech
                    self.words.sort {
                        $0.partOfSpeech < $1.partOfSpeech
                    }
                    self.filteredWords.sort {
                        $0.partOfSpeech < $1.partOfSpeech
                    }
                }
            }
        }
    }
    
    func filter(by filter: FilterCases) {
        DispatchQueue.main.async {
            withAnimation() {
                var startArray = self.words
                
                switch filter {
                case .none:
                    self.filterState = .none
                    startArray = self.words
                case .noun:
                    self.filterState = .noun
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "noun"})
                case .verb:
                    self.filterState = .verb
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "verb"})
                case .adjective:
                    self.filterState = .adjective
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "adjective"})
                case .adverb:
                    self.filterState = .adverb
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "adverb"})
                case .exclamation:
                    self.filterState = .exclamation
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "exclamation"})
                case .conjunction:
                    self.filterState = .conjunction
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "conjunction"})
                case .pronoun:
                    self.filterState = .pronoun
                    startArray = self.words
                    startArray.removeAll(where: {$0.partOfSpeech != "pronoun"})
                case .favorite:
                    self.filterState = .favorite
                    startArray = self.words
                    startArray.removeAll(where: {$0.isFavorite != true })
                }
                
                self.filteredWords = startArray
            }
        }
    }
    
    func getWords() {
        let fileName = getDocumentsDirectory().appendingPathComponent("words")

        do {
            let words = try Data(contentsOf: fileName)
            self.words = try JSONDecoder().decode([WordModel].self, from: words)
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            let fileName = getDocumentsDirectory().appendingPathComponent("words")
            let words = try JSONEncoder().encode(self.words)
            try words.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
}

enum FetchingStatus {
    case blank
    case ready
    case loading
    case error
}

enum SortingCases {
    case def
    case name
    case partOfSpeech
}

enum FilterCases {
    case none
    case noun
    case verb
    case adjective
    case adverb
    case exclamation
    case conjunction
    case pronoun
    case favorite
}
