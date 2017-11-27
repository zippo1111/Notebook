//
//  HistoryHeaderCell.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation

struct API {

    static let BaseURL = URL(string: "https://dictionary.yandex.net/dicservice.json")
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL!
    }
    
}
