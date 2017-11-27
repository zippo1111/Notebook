//
//  YandexAPISearchViewModel.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class YandexAPISearchViewModel {
    
    // MARK:- Helper для работы с моделью(API)
    private lazy var dataManager = {
        return DataManager(baseURL: API.AuthenticatedBaseURL)
    }()
    
    // Добавлено для избавления от dataSource и delegate таблицы
    // MARK: Outputs
    //public var wordsDataSource : Observable<[Word]>
    
    // MARK: - Properties
    private let _querying = Variable<Bool>(false)
    private let _words = Variable<[Word]>([])
    
    var querying: Driver<Bool> { return _querying.asDriver() }
    var words: Driver<[Word]> { return _words.asDriver() }
    
    // MARK: -
    var hasWords: Bool { return numberOfWords > 0 }
    var numberOfWords: Int { return _words.value.count}
    
    // MARK: -22
    var queryingDidChange: ((Bool) -> ())?
    
    // MARK: -
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    init(query: Driver<String>) {
        
        query
            .throttle(0.5)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (wordToTranslate) in
                
                self?.translateWordUsingYandexAPI(wordToTranslate: wordToTranslate)
                
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Interface
    
    func word(at index: Int) -> Word? {
        
        guard index < _words.value.count else { return nil }
        return _words.value[index]
        
    }
    
    func viewModelForWord(at index: Int) -> WordRepresentable? {
        
        guard let word = word(at: index) else { return nil }
        return WordsViewModel(definition: word.definition, fullTranslation: word.full_translation, shortTranslation: word.short_translation)
        
    }
    
    // MARK: - Helper Methods
    // Обращение к модели
    func translateWordUsingYandexAPI(wordToTranslate: String?) {
        
        guard let wordToTranslate = wordToTranslate,
            wordToTranslate.count > 2 else {
            _words.value = []
            return
        }
        
        _querying.value = true
        
        // Запуск перевода для слова (YandexAPI)
        dataManager.translationForWord(word: wordToTranslate) { (response, error) in
            if let error = error {
                print(error)
            } else if let response = response {
                
                self._querying.value = false
                self._words.value = response.wordWithTranslation
                
            }
            
        }
    }
    
    
    
}
