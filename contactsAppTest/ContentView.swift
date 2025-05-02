//
//  ContentView.swift
//  contactsAppTest
//
//  Created by LorenzoAC on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contactStore = ContactStore()
    @State private var showingAddContact = false
    @State private var reloadContacts = false

    var body: some View {
        NavigationView {
            ZStack {
                ContactsView(reloadTrigger: $reloadContacts)
                    .environmentObject(contactStore)

                    NavigationLink(
                        destination: AddContactView(onSave: {_ in 
                            reloadContacts.toggle()
                            showingAddContact = false
                        })
                            .environmentObject(contactStore),
                                    isActive: $showingAddContact
                                ) {
                                    EmptyView()
                                }
            }
            .navigationBarTitle("Contactos", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        print("Borrar contactos")
                        
                    }) {
                        Image(systemName: "trash")
                    },
                trailing:
                    Button(action: {
                        showingAddContact = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
        }
    }
}
#Preview {
    ContentView()
}
