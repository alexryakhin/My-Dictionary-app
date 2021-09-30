//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Alexander Ryakhin on 5/12/21.
//

import Foundation
import UIKit
import SwiftUI

extension Bundle {
    //i use generic T type here to decode anything i want from almost any JSON Data file.
    func decode<T: Codable>(_ file: String) -> T {
        //getting lication of the file in our bundle and set temporary url constant
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        //setting temporary data constant with Data from the file I found in the bundle
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        //decoder instance
        let decoder = JSONDecoder()
        //format date to read easier
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        //loading data from my data constant
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bandle")
        }
        //returning this data as a generic type.
        return loaded
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
