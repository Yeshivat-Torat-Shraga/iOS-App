//
//  DisplayRabbiModel.swift
//  Yeshivat Torat Shraga
//
//  Created by Benji Tusk on 11/16/21.
//

import Foundation
import SwiftUI

class DisplayRabbiModel: ObservableObject, ErrorShower, SequentialLoader {
    @Published var rabbi: DetailedRabbi
    @Published var content: Content?
    @Published var sortables: [SortableYTSContent]?
    
    @Published internal var loadingContent: Bool = false
    internal var reloadingContent: Bool = false
    @Published internal var retreivedAllContent: Bool = false
    var lastLoadedDocumentID: FirestoreID?
    internal var calledInitialLoad: Bool = false
    
    var showError: Bool = false
    internal var errorToShow: Error?
    internal var retry: (() -> Void)?
    
    init(rabbi: DetailedRabbi) {
        self.rabbi = rabbi
    }
    
    func load(next increment: Int = 10) {
        self.loadingContent = true
        
        let group = DispatchGroup()
        
        group.enter()
        FirebaseConnection.loadContent(options: (limit: increment, includeThumbnailURLs: true, includeDetailedAuthors: false, startFromDocumentID: lastLoadedDocumentID), matching: rabbi) { results, error in
                guard let results = results else {
                    self.showError(error: error ?? YTSError.unknownError, retry: {
                        self.load(next: increment)
                    })
                    group.leave()
                    fatalError(error!.localizedDescription)
                }
            
                withAnimation {
                    self.content = results.content
                    
                    var sortables: [SortableYTSContent] = []
                    for audio in self.content!.audios {
                        sortables.append(audio.sortable)
                    }
                    for video in self.content!.videos {
                        sortables.append(video.sortable)
                    }
                    
                    self.sortables = sortables.sorted(by: { lhs, rhs in
                        return lhs.date! > rhs.date!
                    })
                }
                group.leave()
                
                DispatchQueue.global(qos: .background).async {
                    for audio in self.content!.audios {
                        if !(audio.author is DetailedRabbi) {
                            audio.author = self.rabbi
                        }
                    }
                    for video in self.content!.videos {
                        if !(video.author is DetailedRabbi) {
                            video.author = self.rabbi
                        }
                    }
                }
            }
        group.notify(queue: .main) {
            withAnimation {
                self.loadingContent = false
                self.reloadingContent = false
            }
        }
    }
    
    func initialLoad() {
        self.calledInitialLoad = true
        load()
    }
    
    func reload() {
        if !reloadingContent {
            reloadingContent = true
            self.lastLoadedDocumentID = nil
            self.content = nil
//            self.favoriteContent = nil
            self.calledInitialLoad = false
            initialLoad()
//            loadFavorites()
        }
    }
}
