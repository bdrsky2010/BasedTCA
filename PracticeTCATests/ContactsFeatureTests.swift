//
//  ContactsFeatureTests.swift
//  PracticeTCATests
//
//  Created by Minjae Kim on 1/2/25.
//

import Testing
import Foundation
import ComposableArchitecture

@testable import PracticeTCA

@MainActor
struct ContactsFeatureTests {
    @Test
    func addFlowNonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName("Blob Jr."))
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
            $0.destination = nil
        }
    }
    
    @Test
    func addFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "")
                )
            )
        }
        
        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.destination?.addContact?.contact.name = "Blob Jr."
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Blob Jr.")
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
        }
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
}
