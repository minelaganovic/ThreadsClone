//
//  PostView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI
extension View {
    @ViewBuilder func ifLet<V>(_ value: V?, transform: (Self, V) -> Self) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

struct PostView: View {
    var user: User
    var post: Post
    
    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }

    var body: some View {
        HStack {
            Spacer() // Add spacer to push content to the center
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack {
                        AsyncImage(
                            url: URL(string: user.profilePic),
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(30)
                            }, placeholder: {
                                Circle()
                                    .foregroundColor(Color("Gray").opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(30)
                            }
                        )
                    }
                    
                    Text(user.username)
                        .customFont(.title3)
                    Spacer()
                    Text("1h")
                        .customFont(.body)
                    Image(systemName: "ellipsis")
                        .customFont(.title3)
                }
                .foregroundColor(Color("Text"))
                
                Text(post.text ?? "")
                    .customFont(.subheadline)
                    .foregroundColor(Color("Text"))
                
                if let imgURL = post.img, let url = URL(string: imgURL) {
                    AsyncImage(
                        url: url,
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 350, height: 150)
                                .cornerRadius(10)
                        }, placeholder: {
                            Rectangle()
                                .foregroundColor(Color("Gray").opacity(0.2))
                                .frame(width: 350, height: 150)
                                .cornerRadius(10)
                        }
                    )
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "heart")
                    Image(systemName: "text.bubble")
                    Image(systemName: "repeat")
                    Image(systemName: "paperplane")
                }
                .padding(.top)
                .customFont(.title2)
                .foregroundColor(Color("Text"))
                
                Text("\(post.likesCount) likes • \(post.replies.count) replies")
                    .customFont(.footnote)
                    .foregroundColor(Color("Gray"))
            }
            .background(Color("Primary"))
            .padding(.horizontal)
        }
    }
}


struct PostView_Previews: PreviewProvider {
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

        return PostView(user: sampleUser, post: samplePost)
    }
}
