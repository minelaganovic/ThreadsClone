//
//  LogOutView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 20.12.23..
//

import SwiftUI
struct SettingsView: View {
    @State private var isLogoutVisible = false
        //@State private var userPosts: [Post] = []

        // Assuming you have a ProfileViewModel
        @ObservedObject private var profileViewModel = ProfileViewModel()
    var body: some View {
        List {
            NavigationLink(destination: ThreadsRootView()) {
                Text("Notifications")
            }
            NavigationLink(destination: ThreadsRootView()) {
                Text("Account")
            }
            NavigationLink(destination: ThreadsRootView()) {
                Text("Privacy")
            }
            NavigationLink(destination: ThreadsRootView()) {
                Text("Help")
            }
            NavigationLink(destination: ProfileView(viewModel: profileViewModel)) {
                            Text("About")
            }
            NavigationLink(destination: LoginView()
                .navigationBarBackButtonHidden(true)) {
                Text("Logout")
                    .foregroundColor(.red)
                    
            }
        }
        .sheet(isPresented: $isLogoutVisible) {
            ContentView()
        }
        .navigationTitle("Settings")
    }
}

