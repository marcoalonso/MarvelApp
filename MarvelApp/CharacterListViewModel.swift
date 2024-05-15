//
//  CharacterListViewModel.swift
//  MarvelApp
//
//  Created by Marco Alonso Rodriguez on 14/05/24.
//

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchCharacters() {
        MarvelAPI.shared.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                DispatchQueue.main.async {
                    self?.characters = characters
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

