//
//  Root.swift
//  Yeshivat Torat Shraga
//
//  Created by David Reese on 11/9/21.
//

import Foundation
import SwiftUI

class RootModel: ObservableObject, ErrorShower {
    @AppStorage("firstLaunch")
    private var isFirstLaunch = true
    @Published var showOnboarding = false
    internal var retry: (() -> Void)?
    @Published var showError: Bool = false
    internal var errorToShow: Error?
        
    static var audioPlayer: AudioPlayer = AudioPlayer()
    static var audioPlayerBinding: Binding<AudioPlayer> = Binding {
        audioPlayer
    } set: { val in
        audioPlayer = val
    }
    
    @Published var showLoadingScreen = true
    @Published var homeView: HomeView?
    @Published var favoritesView = FavoritesView(playerAudio: RootModel.audioPlayerBinding.audio)
    @Published var newsView = NewsView(playerAudio: RootModel.audioPlayerBinding.audio)
    @Published var settingsView = SettingsView(playerAudio: RootModel.audioPlayerBinding.audio)
    
    @Published var alert: Alert?
    
    init() {
        if isFirstLaunch {
            showOnboarding = true
            isFirstLaunch = false
        }
        let appearance = UITabBar.appearance()
        appearance.standardAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        if #available(iOS 15.0, *) {
            let scrollEdgeAppearance = UITabBarAppearance()
            scrollEdgeAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
            appearance.scrollEdgeAppearance = scrollEdgeAppearance
        }
        
        self.homeView = HomeView(hideLoadingScreen: {
            self.showLoadingScreen = false
        }, showErrorOnRoot: { error, retry in
            self.showError(error: error, retry: retry!)
        }, playerAudio: RootModel.audioPlayerBinding.audio)        
    }
    
}
