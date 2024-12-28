//
//  PracticeTCAApp.swift
//  PracticeTCA
//
//  Created by Minjae Kim on 12/22/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct PracticeTCAApp: App {
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: PracticeTCAApp.store)
        }
    }
}
