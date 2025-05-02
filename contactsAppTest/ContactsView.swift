//
//  ContactsView.swift
//  contactsAppTest
//
//  Created by LorenzoAC on 4/30/25.
//

import SwiftUI
import UIKit

struct ContactsView: UIViewControllerRepresentable {
    @Binding var reloadTrigger: Bool

    func makeUIViewController(context: Context) -> ContactsViewController {
        return ContactsViewController()
    }

    func updateUIViewController(_ uiViewController: ContactsViewController, context: Context) {
        if reloadTrigger {
            uiViewController.perform(#selector(ContactsViewController.loadContactsFromUserDefaults))
                }
    }
}


