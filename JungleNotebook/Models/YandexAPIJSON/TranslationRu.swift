//
//  TranslationIntoRU.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//

/**
 Модель, содержащая блоки перевода на русский язык
 */
import Foundation
import SwiftyJSON

// Получения списка перевода в виде массива от сервера
struct TranslationRu {
    
    let ruLangTranslation: Array<JSON> // Сырые данные от сервера - перевод искомого слова
    
    var text: String = "" //  Перевод в форме одного слова
    var combinedTranslation: String = "" // Перевод в форме объединения строк
    
    init(json: JSON) {
        self.ruLangTranslation = json["tr"].arrayValue
        
        let lastIndex:Int = self.ruLangTranslation.endIndex
        var counter:Int = 1
        
        for result in self.ruLangTranslation {
            self.text = result["text"].stringValue
            
            let comma = (lastIndex == counter) ? "" : ", "
            
            self.combinedTranslation += "\(text)\(comma)"
            
            counter += 1
        }
        
    }
    
}


