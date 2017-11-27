//
//  Word.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//

import Foundation

struct Word {
    
    fileprivate enum Keys {
        
        static let definition = "definition"
        static let full_translation = "full_translation"
        static let short_translation = "short_translation"
        
    }
    
    // MARK: - Properties
    
    let definition: String
    let full_translation: String
    let short_translation: String
       
    // MARK: -
    
    var asDictionary: [String: Any] {
        return [ Keys.definition: definition,
                 Keys.full_translation : full_translation,
                 Keys.short_translation: short_translation ]
    }
    
}

extension Word {
    
    // MARK: - Initialization
    
    init?(dictionary: [String: Any]) {
        
        guard let definition = dictionary[Keys.definition] as? String else { return nil }
        guard let full_translation = dictionary[Keys.full_translation] as? String else { return nil }
        guard let short_translation = dictionary[Keys.short_translation] as? String else { return nil }
        
        self.definition = definition
        self.full_translation = full_translation
        self.short_translation = short_translation
    }
    
}

extension Word: Equatable {
    
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return
            lhs.definition == rhs.definition &&
            lhs.full_translation == rhs.full_translation &&
            lhs.short_translation == rhs.short_translation
    }
    
}

