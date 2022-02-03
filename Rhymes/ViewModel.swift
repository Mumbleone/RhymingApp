//
//  ViewModel.swift
//  Rhymes
//
//  Created by Student on 4/19/21.
//

import Foundation
import Combine
class ViewModel: ObservableObject {
        private let repo: Repository = RepositoryImpl()
        private var cancellables: [AnyCancellable] = []
        @Published
        var viewState: ViewState = .initial

    enum ViewState {
        case initial
        case error(String)
        case loading
        case rhymes([String])
    }
    
    private func makeNetworkCall(cleanWord: String) {
            cancellables.append(repo.getRhymes(word: cleanWord).mapError{ (error) -> Error in
                print(error)
                let description = error.localizedDescription
                if description.contains("it is missing") {
                    self.viewState = .error("No Rhymes Could be found for \(cleanWord)")
                } else {
                    self.viewState = .error(error.localizedDescription)
                }
                return error
            }.sink(receiveCompletion: {_ in }, receiveValue: { response in
                self.viewState = .rhymes(response.rhymes.all)
            }))
    }
    
    private func getCleanWord(word: String) -> String {
            let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            return word.filter {okayChars.contains($0) }
    }
    
    func onGetRhymesClicked(word: String) {
        let i = getCleanWord(word: word)
        if i.isEmpty {
           return viewState = .error("Must be a valid word")
    }
        viewState = .loading
        makeNetworkCall(cleanWord: i)
    }
}
