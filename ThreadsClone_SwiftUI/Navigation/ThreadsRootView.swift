//
//  ThreadsRootView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct ThreadsRootView: View {
    @State var selectedTab: Tabs = .home
    @State private var userPosts: [Post] = []
    @ObservedObject private var profileViewModel = ProfileViewModel()  // Assuming you have a ProfileViewModel

    init() {
        UITableView.appearance().isHidden = true
    }
    
    var body: some View {
        VStack{
            ZStack{
                switch selectedTab {
                case .home:
                    HomeView()
                case .search:
                    SearchView()
                case .add_post:
                    NewPostView()
                case .notifications:
                    NotificationsView()
                case .profile:
                    ProfileView(viewModel: profileViewModel)  // Pass the viewModel to ProfileView
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            TabBarView(selectedTab: $selectedTab)
                .navigationBarBackButtonHidden(true)
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadsRootView()
    }
}

