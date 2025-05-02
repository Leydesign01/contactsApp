//
//  AddContactView.swift
//  contactsAppTest
//
//  Created by LorenzoAC on 4/30/25.
//

import Foundation
import SwiftUI

class ContactDataWrapper: NSObject, Codable, Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phone: String

    init(firstName: String, lastName: String, phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}


public struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var contactStore: ContactStore
//    @Binding var reloadTrigger: Bool
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    var onSave: ((ContactDataWrapper) -> Void)?
    
    init(onSave: ((ContactDataWrapper) -> Void)? = nil) {
        self.onSave = onSave
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://randomuser.me/api/portraits/men/10.jpg")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 150, height: 150)
            }
            
            TextField("Nombre", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Apellido", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Teléfono", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
            
            Button(action: {
                if firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
                    lastName.trimmingCharacters(in: .whitespaces).isEmpty ||
                    phone.trimmingCharacters(in: .whitespaces).isEmpty {
                    
                    alertMessage = "Por favor, completa todos los campos."
                    showAlert = true
                    return
                }
                
                let contact = ContactDataWrapper(
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone
                )
                
//                reloadTrigger.toggle()
                saveContactToUserDefaults(contact: contact)
                contactStore.contacts.append(contact)
                onSave?(contact)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Guardar")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Campos incompletos"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Nuevo Contacto", displayMode: .inline)
        .navigationBarItems(leading:
            Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

func saveContactToUserDefaults(contact: ContactDataWrapper) {
    let contactDict = [
        "firstName": contact.firstName,
        "lastName": contact.lastName,
        "phone": contact.phone
    ]

    var savedContacts = UserDefaults.standard.data(forKey: "savedContacts")
    var contactsArray: [[String: String]] = []

    if let data = savedContacts,
       let decoded = try? JSONDecoder().decode([[String: String]].self, from: data) {
        contactsArray = decoded
    }

    contactsArray.append(contactDict)

    if let encoded = try? JSONEncoder().encode(contactsArray) {
        UserDefaults.standard.set(encoded, forKey: "savedContacts")
    }
    UserDefaults.standard.synchronize()


}




#Preview {
    AddContactView()
}
