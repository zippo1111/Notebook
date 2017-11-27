//
//  Word.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//

import XCTest

extension XCTestCase {

    // MARK: - Helper Methods

    func loadStubFromBundle(withName name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)

        return try! Data(contentsOf: url!)
    }

}
