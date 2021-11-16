//
//  Root.swift
//  Yeshivat Torat Shraga
//
//  Created by David Reese on 11/9/21.
//

import Foundation

class RootModel: ObservableObject {

    @Published var rebbeim: [Rabbi]?
    
    init() {
        rebbeim = Rabbi.samples
//        FirebaseConnection.loadRabbis { results, error in
//            guard let results = results else {
//                fatalError(error!.localizedDescription)
//            }
//            rebbeim = results.rabbis
//        }
    }
}
