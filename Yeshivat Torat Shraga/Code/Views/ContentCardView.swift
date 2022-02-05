//
//  ContentCardView.swift
//  Yeshivat Torat Shraga
//
//  Created by Benji Tusk on 02/02/2022.
//

import SwiftUI

struct SortableContentCardView<Content: SortableYTSContent>: View {
    let content: Content
    var body: some View {
        if let audio = content.audio {
            ContentCardView(content: audio)
        } else if let video = content.video {
            ContentCardView(content: video)
        }
    }
}

struct ContentCardView<Content: YTSContent>: View {
    @State var isShowingPlayerSheet = false
    let content: Content
    let isAudio: Bool
    
    init(content: Content) {
        self.content = content
        self.isAudio = (content.sortable.audio != nil)
    }
    
    var body: some View {
        Button(action: {
            if isAudio {
                RootModel.audioPlayer.play(audio: content.sortable.audio!)
                isShowingPlayerSheet = true
            } else {
//                 Video Player goes here
            }
        }) {
            ZStack {
                if isAudio {
                    // If the card is for Audios
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                Gradient.Stop(
                                    color: Color(
                                        hue: 0.616,
                                        saturation: 0.431,
                                        brightness: 0.510),
                                    location: 0),
                                Gradient.Stop(
                                    color: Color(
                                        hue: 0.610,
                                        saturation: 0.5,
                                        brightness: 0.19),
                                    location: 1),
                            ]
                        ),
                        startPoint: UnitPoint.bottomLeading,
                        endPoint: UnitPoint.trailing)
                        Blur(style: .systemUltraThinMaterial)
                } else {
                    // If the card is for Videos
                    DownloadableImage(object: content)
                    Blur(style: .systemUltraThinMaterial)
                }
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(content.title)
                                    .font(.title2)
                                    .bold()
                                    .lineLimit(2)
                                Spacer()
                            }
                            
                            HStack {
                                Text(content.author.name)
                                Spacer()
                            }
                            
                        }
                        if let detailedRabbi = content.author as? DetailedRabbi {
                            DownloadableImage(object: detailedRabbi)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .background(Color("Gray"))
                                .clipShape(Circle())
                                .clipped()
                                .shadow(radius: 2)
                        }
                    }
                    Spacer()
                    HStack {
                        if let month = Date.monthNameFor(content.date.get(.month)) {
                            let yearAsString = String(content.date.get(.year))
                            Text("\(month) \(content.date.get(.day)), \(yearAsString)")
                        }
                        Spacer()
                        if let duration = content.duration {
                            HStack(spacing: 4) {
                                Image(systemName: isAudio
                                      ? "mic"
                                      : "play.rectangle.fill")
                                Text(timeFormattedMini(totalSeconds: duration))
                            }
                        }
                    }.font(.caption)
                }
                .padding()
                .clipped()

            }
            .foregroundColor(.primary)
            .frame(width: 250, height: 150)
            .clipped()
            
            
        }
        .buttonStyle(BackZStackButtonStyle())
        .cornerRadius(UI.cornerRadius)
        .shadow(radius: UI.shadowRadius)
        .sheet(isPresented: $isShowingPlayerSheet) {
            RootModel.audioPlayer
        }
    }
}

struct ContentCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentCardView(content: Audio.sample)
            ContentCardView(content: Video.sample)
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}