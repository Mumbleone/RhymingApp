//
//  Repository.swift
//  Rhymes
//
//  Created by Adrian Devezin on 4/19/21.
//

import Foundation
import Combine

protocol Repository {
    func getRhymes(word: String) -> AnyPublisher<RhymesResponse, Error>
}

class RepositoryImpl: Repository {
    func getRhymes(word: String) -> AnyPublisher<RhymesResponse, Error> {
        RhymesApi.getRhymes(word: word)
    }
}

