//
//  WordsInHistoryViewModel.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import UIKit

struct WordsInHistoryViewModel {
    
    // MARK:- User's search history block
    var favoriteWords = UserDefaults.loadWords()
    
    // Есть слова в истории поиска
    fileprivate var hasFavoriteWords: Bool {
        return favoriteWords.count > 0
    }
    
    // MARK: - Properties
    
    let definitionHist: String?
    //    let fullTranslation: String?
    let shortTranslationHist: String?
    
    // MARK: - Initialization
    
    init(definition: String? = nil,
         shortTranslation: String? = nil) {
        self.definitionHist = definition
        self.shortTranslationHist = shortTranslation
    }
    
    func word(at index: Int) -> Word? {
        print("before favoriteWords[index]: ", favoriteWords[index])
        guard index < favoriteWords.count else { return nil }
        print("after favoriteWords[index]: ", favoriteWords[index])
        
        return favoriteWords[index]
        
    }
//
    func viewModelForFavoriteWord(at index: Int) -> WordRepresentable? {
        //print("word before VM: ", word)
        let word = favoriteWords[index]
        
        print("word from VM: ", word)
        
        return WordsViewModel(definition: word.definition, fullTranslation: word.full_translation, shortTranslation: word.short_translation)
        
    }
    
}

extension WordsInHistoryViewModel: WordRepresentable {
    var definition: String {
        if let definition = definitionHist {
            return definition
        }
        
        return "Unknown Definition"
    }
    
    var full_translation: String {
        return "None"
    }
    
    var short_translation: String {
        if let shortTranslation = shortTranslationHist {
            return shortTranslation
        }
        
        return "Unknown DefshortTranslationinition"
    }
    
    
    
    
    
}

