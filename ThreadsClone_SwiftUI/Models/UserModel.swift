//
//  UserModel.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//
import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let username: String
    let profilePic: String
    let bio: String
    var followers: [String]?
    var following: [String]?

    var followersCount: Int {
            return followers?.count ?? 0
        }
    var followingCount: Int {
            return following?.count ?? 0
        }
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
            case email
            case username
            case profilePic
            case bio
            case followers
            case following
        }
    init(id: String, name: String, email: String, username: String, profilePic: String, bio: String, followers: [String], following: [String]) {
           self.id = id
           self.name = name
           self.email = email
           self.username = username
           self.profilePic = profilePic
           self.bio = bio
           self.followers = followers
           self.following = following
       }
}

struct UserList {
    static let Users = [
        User(id: "4537ftr",
            name: "Ime Prezime",
            email: "email@gmail.com",
            username: "user.name",
            profilePic: "https://res.cloudinary.com/dixnmkl8d/image/upload/v1704796879/cld-sample.jpg",
            bio: "testiranjeee",
            followers: ["follower1", "follower2"],
            following: ["following1", "following2"]
        )
    ]
}
