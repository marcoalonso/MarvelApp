//
//  ContentView.swift
//  MarvelApp
//
//  Created by Marco Alonso Rodriguez on 14/05/24.
//

import SwiftUI
import Kingfisher

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.characters, id: \.id) { character in
                    HStack {
                        KFImage(URL(string: "\(character.thumbnail.path).\(character.thumbnail.thumbnailExtension)"))
                            .resizable()
                            .frame(width: 150, height: 150)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(12)
                        
                        Text(character.name ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
                
                
            }
            .navigationTitle("Marvel Characters")
            .onAppear {
                viewModel.fetchCharacters()
            }
        }
    }
}

#Preview {
    CharacterListView()
}
