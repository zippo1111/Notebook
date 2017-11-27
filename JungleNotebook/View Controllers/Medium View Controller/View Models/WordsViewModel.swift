//
//  WordsViewModel.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import UIKit

struct WordsViewModel {
    
    // MARK: - Properties
    
    let definitionVM: String?
    let fullTranslation: String?
    let shortTranslation: String?
    
    // MARK: - Initialization
    
    init(definition: String? = nil, fullTranslation: String? = nil, shortTranslation: String? = nil) {
        self.definitionVM = definition
        self.fullTranslation = fullTranslation
        self.shortTranslation = shortTranslation
    }
    
    var definition: String {
        return self.definitionVM!
    }
    
    var full_translation: String {
        return self.fullTranslation!
    }
    
    var short_translation: String {
        return self.shortTranslation!
    }
    
}

extension WordsViewModel: WordRepresentable {
  
}
