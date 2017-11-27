//
//  YandexResponseRu.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import SwiftyJSON

class YandexResponseRu {
    
    let translations: [TranslationRu]
    let wordToTranslate: [WordEn]
    var wordWithTranslation: [Word]
    
    init(json: JSON) throws {
        guard let translJson = json["en-ru"]["regular"].array, let inputWordJson = json["en-ru"]["regular"].array else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON not valid."])
        }
       
        self.translations = translJson.map({ TranslationRu(json: $0) })
        self.wordToTranslate = inputWordJson.map({ WordEn(json: $0) })
        self.wordWithTranslation = []
        
        // Mapping to Word (будет использоваться ViewModel'ью)
        if self.wordToTranslate.count > 0 {
            let theword:WordEn = self.wordToTranslate[0]
            
            var counter: Int = 1
            var firstWordRu: String = "" // Запишем только первый перевод (простой)
            var full_fledged_combined_translation: String = "" // Полный образец переводов
            
            for thetranslation in self.translations {
                
                if counter == 1 {
                    firstWordRu = thetranslation.text
                }
                
//                self.wordWithTranslation.append(Word(
//                    definition: theword.enWord,
//                    full_translation: thetranslation.combinedTranslation,
//                    short_translation: thetranslation.text))
                
                full_fledged_combined_translation += "\(counter)). \(thetranslation.combinedTranslation)\n"
                
                counter += 1
            }
            
            self.wordWithTranslation.append(Word(
                definition: theword.enWord,
                full_translation: full_fledged_combined_translation,
                short_translation: firstWordRu))
            
            print("self.wordWithTranslation > ", self.wordWithTranslation)
            
        } 
        
    }
    
    
}


