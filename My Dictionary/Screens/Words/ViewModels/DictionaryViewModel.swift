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
    @Published var definitions: [String] = []
    @Published var words: [WordModel] = [] {
        didSet {
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
    
    init() {
        let fileName = getDocumentsDirectory().appendingPathComponent("words")

        do {
            let words = try Data(contentsOf: fileName)
            self.words = try JSONDecoder().decode([WordModel].self, from: words)
        }
        catch {
            print("\(error.localizedDescription)")
        }
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fetchData() {
        status = .loading
        if inputWord != "" {
            let stringURL = "https://api.dictionaryapi.dev/api/v2/entries/en_US/\(inputWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))"
            guard let url = URL(string: stringURL) else {
                print("incorrect url")
                return
            }
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("can't get data")
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
                        self.status = .error
                    }
                    print(error.localizedDescription)
                }
            }.resume()
        } else {
            print("type a word")
            return
        }
    }
}

enum FetchingStatus {
    case blank
    case ready
    case loading
    case error
}
