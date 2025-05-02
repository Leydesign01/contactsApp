//
//  ContactStore.swift
//  contactsAppTest
//
//  Created by LorenzoAC on 4/30/25.
//


import Foundation
import Combine

class ContactStore: ObservableObject {
    @Published var contacts: [ContactDataWrapper] = [] {
        didSet {
            saveContacts()
        }
    }

    private let contactsKey = "savedContacts"

    init() {
        loadContacts()
    }

    private func saveContacts() {
        
       let contactDicts = contacts.map { contact in
                return [
                    "firstName": contact.firstName,
                    "lastName": contact.lastName,
                    "phone": contact.phone
                ]
            }
            UserDefaults.standard.set(contactDicts, forKey: contactsKey)
      
    }

    private func loadContacts() {
        if let savedArray = UserDefaults.standard.array(forKey: contactsKey) as? [[String: String]] {
                self.contacts = savedArray.map { dict in
                    ContactDataWrapper(
                        firstName: dict["firstName"] ?? "",
                        lastName: dict["lastName"] ?? "",
                        phone: dict["phone"] ?? ""
                    )
                }
            }
    
    }
}


