//
//  WordTableViewCell.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import UIKit

class WordTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "WordCell"
    
    // MARK: - Properties
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet weak var detailTextLeading: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Configuration
    
    func configure(withViewModel viewModel: WordRepresentable) {
        
        print("simple main")
        
        // Правка для шрифта ("вытянутые символы" в списке rangeOfChars требуют дополнительного отступа со шрифтом Zapfino. English variant
        
        let firstCharEn = viewModel.definition.first
        let rangeOfEnChars = "qpyfgj"
        let spacedStringEn = addSpaceToFirstLetter(firstChar: firstCharEn!, textToChange: viewModel.definition, charsRange: rangeOfEnChars)
        
        mainLabel.text = spacedStringEn
        
        // Правка для шрифта ("вытянутые символы" в списке rangeOfChars требуют дополнительного отступа со шрифтом Zapfino
        
        let firstCharRu = viewModel.short_translation.first
        let rangeOfRuChars = "рзуф"
        let spacedStringRu = addSpaceToFirstLetter(firstChar: firstCharRu!, textToChange: viewModel.short_translation, charsRange: rangeOfRuChars)
        
        detailTextLeading.constant = rangeOfRuChars.contains(firstCharRu!) ? 12 : 16
        detailLabel.text = spacedStringRu
        
    }
    
    // MARK:- Helper methods
    private func addSpaceToFirstLetter(firstChar: Character, textToChange:String, charsRange: String) -> String {
        
        var spaceString = charsRange.contains(firstChar) ? " " : ""
        spaceString.append (textToChange)
        return spaceString
        
    }
    
}
