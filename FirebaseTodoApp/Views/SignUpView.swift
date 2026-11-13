//
//  SignUpView.swift
//  FirebaseTodoApp
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundStyle(.blue)

            Text("Create a new account")
                .font(.title2)
                .bold()

            InputField(placeholder: "Email", icon: "envelope", text: $email)
            InputField(placeholder: "Password (min 6 characters)", icon: "lock", text: $password, isSecure: true)
            InputField(placeholder: "Confirm password", icon: "lock.rotation", text: $confirmPassword, isSecure: true)

            if let message = authViewModel.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button {
                authViewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
            } label: {
                HStack {
                    if authViewModel.isLoading {
                        ProgressView().tint(.white)
                    }
                    Text("Sign Up")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(authViewModel.isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
        .onAppear {
            authViewModel.errorMessage = nil
        }
    }
}

