//
//  FirebaseTodoAppApp.swift
//  FirebaseTodoApp
//
//  CSE 3218 - Mobile Computing Lab Assignment
//  A simple to-do list app using SwiftUI + Firebase Auth + Cloud Firestore.
//

import SwiftUI
import FirebaseCore

@main
struct FirebaseTodoAppApp: App {

    // The AuthViewModel lives for the whole app, so we create it with @StateObject
    // and share it with every screen using .environmentObject(...)
    @StateObject private var authViewModel: AuthViewModel

    init() {
        // Lab 4: Firebase must be configured once, when the app launches,
        // before we use Auth or Firestore anywhere.
        FirebaseApp.configure()
        _authViewModel = StateObject(wrappedValue: AuthViewModel())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
