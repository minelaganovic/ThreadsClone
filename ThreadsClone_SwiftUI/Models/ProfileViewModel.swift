//
//  ProfileViewModel.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 11.1.24..
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userPosts: [Post] = []
    @Published var followersCount: Int = 0
    @Published var followingCount: Int = 0

    func fetchUserPosts(username: String) {
        APIManager.shared.getUserPosts(username: username) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.userPosts = posts
                }
            case .failure(let error):
                print("Error fetching user posts: \(error)")
            }
        }
    }
}

