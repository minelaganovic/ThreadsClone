//
//  ReplyView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct ReplyView: View {
    var reply: Post.Reply
    var user: User

    var body: some View {
                HStack(alignment: .top, spacing: 10) {
                    VStack{

                        AsyncImage(
                            url: URL(string: user.profilePic ),
                            content: { image in
                                image
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .frame(width: 60, height: 60)
                                 .cornerRadius(30)
                            }, placeholder: {
                                Circle()
                                    .foregroundColor(Color("Gray").opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(30)
                            }
                        )
                        
                        Rectangle()
                            .frame(maxWidth: 2, maxHeight: .infinity)
                            .foregroundColor(Color("Gray").opacity(0.3))
                        
                        HStack(alignment: .bottom) {
                            Circle()
                                .foregroundColor(Color("Gray").opacity(0.3))
                                .frame(maxWidth: 15, maxHeight: 15)
                            Circle()
                                .foregroundColor(Color("Gray").opacity(0.3))
                                .frame(maxWidth: 30, maxHeight: 30)
                        }
                        Circle()
                            .frame(maxWidth: 10, maxHeight: 10)
                            .foregroundColor(Color("Gray").opacity(0.3))
                    }
     
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(user.username ?? "")
                                .customFont(.title3)
                            Spacer()
                            Text("5h")
                                .customFont(.body)
                            Image(systemName: "ellipsis")
                                .customFont(.title3)
                        }
                        .foregroundColor(Color("Text"))
                        
                        Text("Replying to \(reply.username ?? "")")
                            .customFont(.caption)
                            .foregroundColor(Color("Text"))
                            .padding(10)
                        
                        Text(reply.text)
                            .customFont(.caption)
                            .foregroundColor(Color("Text"))
                        
                        HStack(spacing: 10) {
                            Image(systemName: "heart")
                            Image(systemName: "text.bubble")
                            Image(systemName: "repeat")
                            Image(systemName: "paperplane")
                        }
                        .padding(.top)
                        .customFont(.title2)
                        .foregroundColor(Color("Text"))
                        
                        Text("1 replies • 0 likes")
                            .customFont(.footnote)
                            .foregroundColor(Color("Gray"))
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .background(Color("Primary"))
                .padding(.horizontal)
            }
}


struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(id: "4537ftr",
                              name: "Ime Prezime",
                              email: "email@gmail.com",
                              username: "user.name",
                              profilePic: "https://res.cloudinary.com/dixnmkl8d/image/upload/v1704796879/cld-sample.jpg",
                              bio: "testiranjeee",
                              followers: ["follower1", "follower2"], // Example followers
                              following: ["following1", "following2"]
        )
        
        let samplePost = Post(
            id: "1",
            postedBy: "user123",
            text: "This is a sample post",
            img: "sampleImageURL",
            likes: ["user456", "user789"],
            replies: [
                Post.Reply(userId: "user456", text: "Reply 1", userProfilePic: "user456Image", username: "User456"),
                Post.Reply(userId: "user789", text: "Reply 2", userProfilePic: "user789Image", username: "User789")
            ]
        )
                
                return PostView(user: sampleUser,post: samplePost)
    }
}
