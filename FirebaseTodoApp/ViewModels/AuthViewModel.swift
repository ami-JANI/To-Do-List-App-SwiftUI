//
//  AuthViewModel.swift
//  FirebaseTodoApp
//
//  MVVM: the ViewModel talks to Firebase Auth, the Views only show its data.
//

import Foundation
import FirebaseAuth

/// A class (reference type), so every view that receives it shares the same object.
/// Firebase calls our completion handlers on the main thread, so it is safe
/// to update the @Published properties inside them.
final class AuthViewModel: ObservableObject {

    // @Published: when these change, every view that uses them is redrawn
    @Published var user: User?              // Optional: nil means "nobody is signed in"
    @Published var errorMessage: String?
    @Published var isLoading = false

    // Computed property
    var isSignedIn: Bool {
        user != nil
    }

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        // Firebase tells us whenever the user signs in or signs out
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    // MARK: - Sign up

    func signUp(email: String, password: String, confirmPassword: String) {
        // guard: stop early when the input is wrong
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        if let problem = validate(email: email, password: password) {
            errorMessage = problem
            return
        }

        isLoading = true
        errorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            self?.isLoading = false
            // optional chaining + optional binding
            if let error {
                self?.errorMessage = error.localizedDescription
            }
            // On success the auth listener above sets `user`, and RootView shows the tasks.
        }
    }

    // MARK: - Sign in

    func signIn(email: String, password: String) {
        if let problem = validate(email: email, password: password) {
            errorMessage = problem
            return
        }

        isLoading = true
        errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            self?.isLoading = false
            if let error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Sign out

    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers

    /// Returns an error message, or nil when the input looks fine.
    private func validate(email: String, password: String) -> String? {
        if email.isEmpty || password.isEmpty {
            return "Please enter your email and password."
        }
        if !email.contains("@") {
            return "Please enter a valid email."
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        return nil
    }
}
