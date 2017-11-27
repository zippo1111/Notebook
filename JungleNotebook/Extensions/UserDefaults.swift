//
//  AnotherViewController.swift
//  JungleNotebook
//
//  Created by Magnolia on 26.11.2017.
//  
//

import Foundation


struct UserDefaultsKeys {
    static let words = "words"
}

extension UserDefaults {

    // MARK: - Words
    
    static func loadWords() -> [Word] {
        guard let dictionaries = UserDefaults.standard.array(forKey: UserDefaultsKeys.words) as? [ [String: Any] ] else {
            return []
        }
        
        return dictionaries.flatMap({ (dictionary) -> Word? in
            return Word(dictionary: dictionary)
        })
    }
    
    static func addWord(_ word: Word) {
        // Load Words
        var words = loadWords()
//        print("words definition:", words[0].definition, "\n")
        print("appendingWord: ", word.definition)
        // Add Word
//        words.append(word)
        words.insert(word, at:0)
        
        // Save Words
        saveWords(words)
    }
    
    // MARK: -
    
    private static func saveWords(_ words: [Word]) {
        // Transform Words
        let dictionaries: [ [String: Any] ] = words.map{ $0.asDictionary }
        
        // Save Locations
        UserDefaults.standard.set(dictionaries, forKey: UserDefaultsKeys.words)
    }
    
    static func removeWord(_ word: Word) {
        // Load Words
        var words = loadWords()
        
        // Fetch Word Index
        guard let index = words.index(of: word) else {
            return
        }
        
        // Remove Word
        words.remove(at: index)
        
        // Save Words
        saveWords(words)
    }
    
}
