//
//  WordEn.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import SwiftyJSON

// Получение списка перевода в виде массива от сервера
struct WordEn {
    
    let enWord: String // Искомое слово для перевода
    
    init(json: JSON) {
        
        self.enWord = json["text"].stringValue
        
    }
    
}


