//
//  YandexAPIViewModelTests.swift
//  JungleNotebookTests
//
//  Created by Magnolia on 25.11.2017.
//

import XCTest
import RxSwift
import RxCocoa
import SwiftyJSON

@testable import JungleNotebook

class YandexAPIViewModelTests: XCTestCase {
    
    var viewModel: YandexAPISearchViewModel!
    
    var jsonData: Data?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // For swift 3/4
        let data = loadStubFromBundle(withName: "yandexResponse", extension: "json")
        let jsonObj = try! JSON(data: data)
        
        let yandexData = try? YandexResponseRu(json: jsonObj)
        
        print("\n yandexResponse: ", yandexData?.translations ?? "error")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
