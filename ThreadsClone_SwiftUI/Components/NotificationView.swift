//
//  NotificationView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct NotificationView: View {
    var user: User
    //var isFollowing: Bool
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: user.profilePic),
                content: { image in
                    image
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 70, height: 70)
                     .cornerRadius(35)
                }, placeholder: {
                    Circle()
                        .foregroundColor(Color("Gray").opacity(0.2))
                        .frame(width: 70, height: 70)
                        .cornerRadius(35)
                }
            )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(user.username)
                    .customFont(.title3)
                Text(user.name)
                    .customFont(.headline)
            }
            Spacer()
            
            if userViewModel.followers.contains(where: { $0.id == user.id }) {
                            Button(action: {
                                userViewModel.followUnfollowUser(user_id: user.id, id: user.id)
                            }) {
                                Text("Follow")
                            }
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .customFont(.headline)
                            .background(Color("Primary"))
                            .foregroundColor(Color("Text"))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                        } else {
                            Button(action: {
                                userViewModel.followUnfollowUser(user_id: user.id, id: user.id)
                            }) {
                                Text("Following")
                            }
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .customFont(.headline)
                            .background(Color("Primary"))
                            .foregroundColor(Color("Text"))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                        }

        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(user: User(id: "someId", name: "someName", email: "someEmail", username: "someUsername", profilePic: "someURL", bio: "someBio", followers: [], following: []),
                         userViewModel: UserViewModel()) 
    }
}

