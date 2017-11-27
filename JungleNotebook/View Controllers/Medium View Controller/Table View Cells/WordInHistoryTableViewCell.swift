//
//  WordInHistoryTableViewCell.swift
//  JungleNotebook
//
//  Created by Magnolia on 26.11.2017.
//  
//

import Foundation
import UIKit

class WordInHistoryTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static let reuseIdentifier = "WordCellHistory"
    
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
        
        mainLabel.text = viewModel.definition
        print("history mainLabel.text ", mainLabel.text)
        
        // Правка для шрифта ("вытянутые символы" в списке rangeOfChars требуют дополнительного отступа со шрифтом Zapfino
        
        let firstChar = viewModel.short_translation.first
        let rangeOfChars = "рзуф"
        var spaceString = rangeOfChars.contains(firstChar!) ? " " : ""
        detailTextLeading.constant = rangeOfChars.contains(firstChar!) ? 12 : 16
        
        spaceString.append (viewModel.short_translation)
        
        detailLabel.text = spaceString
        
    }
    
}
