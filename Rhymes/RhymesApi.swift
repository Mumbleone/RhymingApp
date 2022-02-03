//
//  RhymesApi.swift
//  Rhymes
//
//  Created by Adrian Devezin on 4/19/21.
//

import Foundation

import Foundation
import Combine

enum RhymesApi {
    static let client = ApiClient()
}

extension RhymesApi {
    
    static func getRhymes(word: String) -> AnyPublisher<RhymesResponse, Error> {
        guard let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)/rhymes"), let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create URLCompoents for getCategories")
        }
        let headers = [
            "x-rapidapi-key": "a3c092ea9cmsh49a51aafd0316e5p16b0c1jsn25a9bc471551",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]
        var request = URLRequest(url: components.url!)
        request.allHTTPHeaderFields = headers
        return client.run(request)
            .map(\.value)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

