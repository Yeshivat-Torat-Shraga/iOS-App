//
//  FavoritesView.swift
//  Yeshivat Torat Shraga
//
//  Created by Benji Tusk on 10/12/2021.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var model = FavoritesModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Audio")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    if let audios = model.audios {
                        ScrollView(showsIndicators: false) {
                            HStack {
                                ForEach(audios, id: \.self) { audio in
                                    AudioCardView(audio: audio)
                                        .padding(.vertical)
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        VStack {
                            Text("Yikes, it seems like you don't have any saved Audio Shiurim right now.")
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
