//
//  DataManager.swift
//  JungleNotebook
//
//  Created by Magnolia on 25.11.2017.
//  
//

import Foundation
import SwiftyJSON

enum DataManagerError: Error {

    case unknown
    case failedRequest
    case invalidResponse

}

final class DataManager {

    typealias TranslationCompletion = (YandexResponseRu?, DataManagerError?) -> ()

    // MARK: - Properties

    private let baseURL: URL

    // MARK: - Initialization

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Requesting Data

    func translationForWord(word: String, completion: @escaping TranslationCompletion) {
        // Create URL
        if word.count > 1 {
            var URL = baseURL.appendingPathComponent("lookupMultiple")
            
            var urlComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
            urlComponents?.query = "text=\(word)&dict=en-ru.regular"
            
            URL = (urlComponents?.url!)!
            
            print("baseUrl:", baseURL)
            print("url: ", URL)
            
            // Create Data Task
            URLSession.shared.dataTask(with: URL) { (data, response, error) in
                DispatchQueue.main.async {
                    self.didFetchTranslationData(data: data, response: response, error: error, completion: completion)
                }
                }.resume()
        }
        
    }

    // MARK: - Helper Methods

    private func didFetchTranslationData(data: Data?, response: URLResponse?, error: Error?, completion: TranslationCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let jsonObj = try! JSON(data: data)
                    let yandexData = try YandexResponseRu(json: jsonObj)

                    // Invoke Completion Handler
                    completion(yandexData, nil)

                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidResponse)
                }

            } else {
                completion(nil, .failedRequest)
            }

        } else {
            completion(nil, .unknown)
        }
    }

}
