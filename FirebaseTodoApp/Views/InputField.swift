//
//  InputField.swift
//  FirebaseTodoApp
//
//  A small reusable text field. The parent view owns the text with @State,
//  and passes it here with @Binding so this child view can change it.
//

import SwiftUI

struct InputField: View {
    let placeholder: String
    let icon: String                 // SF Symbol name
    @Binding var text: String
    var isSecure: Bool = false       // default value

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)

            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    InputField(placeholder: "Email", icon: "envelope", text: .constant(""))
        .padding()
}
