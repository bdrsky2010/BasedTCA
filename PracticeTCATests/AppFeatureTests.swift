//
//  AppFeatureTests.swift
//  PracticeTCATests
//
//  Created by Minjae Kim on 12/28/24.
//

import Testing
import ComposableArchitecture

@testable import PracticeTCA

struct AppFeatureTests {
    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
