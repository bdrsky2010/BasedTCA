//
//  ContactsFeature.swift
//  PracticeTCA
//
//  Created by Minjae Kim on 12/29/24.
//

import SwiftUI
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
//        @Presents var addContact: AddContactFeature.State?
//        @Presents var alert: AlertState<Action.Alert>?
        var contacts: IdentifiedArrayOf<Contact> = []
        @Presents var destination: Destination.State?
        var path = StackState<ContactDetailFeature.State>()
    }
    
    enum Action {
        case addButtonTapped
//        case addContact(PresentationAction<AddContactFeature.Action>)
//        case alert(PresentationAction<Alert>)
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)
        
        @CasePathable
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(contact: Contact(id: uuid(), name: ""))
                )
//                state.addContact = AddContactFeature.State(
//                    contact: Contact(name: "")
//                )
                return .none
                
            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
                
            case .destination(.presented(.alert(.confirmDeletion(let id)))):
                state.contacts.remove(id: id)
                return .none
                
            case .destination:
                return .none
                
//            case .alert(.presented(.confirmDeletion(let id))):
//                state.contacts.remove(id: id)
//                return .none
//                
//            case .alert:
//                return .none
                
//            case .addContact(.presented(.delegate(.cancel))):
//                state.addContact = nil
//                return .none
                
//            case .addContact(.presented(.delegate(.saveContact(let contact)))):
////                guard let contact = state.addContact?.contact
////                else { return .none }
//                state.contacts.append(contact)
////                state.addContact = nil
//                return .none
                
//            case .addContact:
//                return .none
                
            case .deleteButtonTapped(let id):
                state.destination = .alert(.deleteConfirmation(id: id))
//                state.destination = .alert(
//                    AlertState {
//                        TextState("Are you sure?")
//                    } actions: {
//                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
//                            TextState("Delete")
//                        }
//                    }
//                )
//                state.alert = AlertState {
//                    TextState("Are you sure?")
//                } actions: {
//                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
//                        TextState("Delete")
//                    }
//                }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
//        .ifLet(\.$addContact, action: \.addContact) {
//            AddContactFeature()
//        }
//        .ifLet(\.$alert, action: \.alert)
    }
}

extension ContactsFeature {
    @Reducer
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}

extension ContactsFeature.Destination.State: Equatable { }

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                TextState("Delete")
            }
        }
    }
}
 
struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    HStack {
                        Text(verbatim: contact.name)
                        Spacer()
                        Button {
                            store.send(.deleteButtonTapped(id: contact.id))
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .animation(.default, value: store.contacts)
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
//            .sheet(item: $store.scope(
//                state: \.addContact,
//                action: \.addContact
//            )) { addContactStore in
//                NavigationStack {
//                    AddContactView(store: addContactStore)
//                }
//            }
            .sheet(item: $store.scope(
                state: \.destination?.addContact,
                action: \.destination.addContact
            )) { addContactStore in
                NavigationStack {
                    AddContactView(store: addContactStore)
                }
            }
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
//            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}

#Preview {
  ContactsView(
    store: Store(
      initialState: ContactsFeature.State(
        contacts: [
            Contact(id: UUID(), name: "Blob"),
            Contact(id: UUID(), name: "Blob Jr"),
            Contact(id: UUID(), name: "Blob Sr"),
        ]
      )
    ) {
      ContactsFeature()
    }
  )
}
