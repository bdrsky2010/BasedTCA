//
//  CounterView.swift
//  PracticeTCA
//
//  Created by Minjae Kim on 12/28/24.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text(verbatim: "\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))
            
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .clipShape(.rect(cornerRadius: 10))
            }
            
            Button(store.isTimerRunning ? "Stop Timer" : "Start Timer") {
                store.send(.toggleTimerButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(verbatim: fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
                ._printChanges()
        }
    )
}
