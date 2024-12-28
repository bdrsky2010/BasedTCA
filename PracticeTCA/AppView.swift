//
//  AppView.swift
//  PracticeTCA
//
//  Created by Minjae Kim on 12/28/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
//    let store1: StoreOf<CounterFeature>
//    let store2: StoreOf<CounterFeature>
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            Tab {
                CounterView(
                    store: store.scope(
                        state: \.tab1,
                        action: \.tab1
                    )
                )
            } label: {
                Text(verbatim: "Counter1")
            }

            Tab {
                CounterView(
                    store: store.scope(
                        state: \.tab2,
                        action: \.tab2
                    )
                )
            } label: {
                Text(verbatim: "Counter2")
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
    )
}
