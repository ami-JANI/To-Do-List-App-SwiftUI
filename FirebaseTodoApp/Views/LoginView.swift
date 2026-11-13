//
//  LoginView.swift
//  FirebaseTodoApp
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    // @State: data that belongs only to this view
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // SF Symbol image with resizable / aspectRatio / frame / clipShape (Lab 2)
                Image(systemName: "checklist")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(24)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(Circle())

                Text("Firebase To-Do")
                    .font(.largeTitle)
                    .bold()

                Text("Sign in to see your tasks")
                    .foregroundStyle(.secondary)

                InputField(placeholder: "Email", icon: "envelope", text: $email)
                InputField(placeholder: "Password", icon: "lock", text: $password, isSecure: true)

                if let message = authViewModel.errorMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                Button {
                    authViewModel.signIn(email: email, password: password)
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView().tint(.white)
                        }
                        Text("Sign In")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(authViewModel.isLoading)

                // Navigating from code (Lab 3): the button only flips a @State value,
                // and .navigationDestination(isPresented:) opens the Sign Up screen.
                Button("Don't have an account? Sign Up") {
                    authViewModel.errorMessage = nil
                    showSignUp = true
                }
                .font(.footnote)

                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

