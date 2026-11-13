//
//  RootView.swift
//  FirebaseTodoApp
//
//  Decides which screen to show: Login (signed out) or the task list (signed in).
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                TaskListView()
            } else {
                LoginView()
            }
        }
        .animation(.default, value: authViewModel.isSignedIn)
    }
}

