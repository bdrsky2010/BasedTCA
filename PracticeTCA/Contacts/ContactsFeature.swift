//
//  ContactsFeature.swift
//  PracticeTCA
//
//  Created by Minjae Kim on 12/29/24.
//

import SwiftUI
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id = UUID()
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(name: "")
                )
                return .none
                
//            case .addContact(.presented(.delegate(.cancel))):
//                state.addContact = nil
//                return .none
                
            case .addContact(.presented(.delegate(.saveContact(let contact)))):
//                guard let contact = state.addContact?.contact
//                else { return .none }
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
                
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
}

 
struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(verbatim: contact.name)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $store.scope(
                state: \.addContact,
                action: \.addContact
            )) { addContactStore in
                AddContactView(store: addContactStore)
            }
        }
    }
}

#Preview {
  ContactsView(
    store: Store(
      initialState: ContactsFeature.State(
        contacts: [
          Contact(name: "Blob"),
          Contact(name: "Blob Jr"),
          Contact(name: "Blob Sr"),
        ]
      )
    ) {
      ContactsFeature()
    }
  )
}
