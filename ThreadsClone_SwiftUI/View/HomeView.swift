import SwiftUI
import Combine

struct HomeView: View {
    @State private var posts: [Post] = []
    @State private var users: [String: User] = [:]
    @State private var isLiked: Bool=false
    @State private var isAddingComment: Bool = false
    @State private var selectedPost: Post?
    @State private var likedPosts: Set<String> = []
    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }

    @Environment(\.colorScheme) var colorScheme
    var logo: String {
        switch colorScheme {
        case .dark:
            return "logo-white"
        case .light:
            return "logo-black"
        @unknown default:
            return "logo-black"
        }
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Image(logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)

                    ForEach(posts, id: \.self) {post in
                        
                       /* Text(post.id ?? "Iddddd")
                            .font(.subheadline)
                            .foregroundColor(Color("Text"))
                        
                            .onAppear {
                                print("Post ID: \(post.id ?? "Iddddd")")
                            }*/
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                if let user = users[post.postedBy] {
                                    AsyncImage(
                                        url: URL(string: user.profilePic),
                                        content: { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(20)
                                        }, placeholder: {
                                            Circle()
                                                .foregroundColor(Color("Gray").opacity(0.2))
                                                .frame(width: 40, height: 40)
                                                .cornerRadius(20)
                                        })
                                    Text(user.username)
                                        .font(.subheadline)

                                    Spacer()
                                    Text("")
                                        .font(.body)
                                        .frame(maxWidth: .infinity)

                                    Image(systemName: "ellipsis")
                                        .font(.title3)
                                        .foregroundColor(Color("Text"))
                                        .frame(maxWidth: .infinity)
                                }

                                Spacer()
                            }
                            if let postText = post.text {
                                Text(postText)
                                    .font(.subheadline)
                                    .foregroundColor(Color("Text"))
                            } else {
                                Text("No text available")
                            }
                            AsyncImage(
                                url: URL(string: post.img ?? ""),
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

                            HStack(spacing: 10) {
                               // HeartButton(isLiked: likedPostsBinding(for: post.id), post: post, likedPosts: $likedPosts)

                                HeartButton(post: post, likedPosts: $likedPosts)

                                Image(systemName: "text.bubble")
                                    .onTapGesture {
                                        self.isAddingComment = true
                                        self.selectedPost = post
                                    }
                                Image(systemName: "repeat")
                                Image(systemName: "paperplane")
                            }
                            .padding(.top)
                            .font(.title2)
                            .foregroundColor(Color("Text"))
                            .onTapGesture {
                                self.isAddingComment = true
                                self.selectedPost = post
                               }
                            NavigationLink(destination: CommentModalView(isPresented: $isAddingComment, posts: self.posts, selectedPost: self.selectedPost), isActive: $isAddingComment) {
                                EmptyView()
                            }
                            .frame(width: 0, height: 0)
                            .hidden()
                            Text("\(post.likesCount) likes • \(post.repliesCount) replies")
                                .font(.footnote)
                                .foregroundColor(Color("Gray"))
                        }
                        .padding(.horizontal)
                        .background(Color("Primary"))
                    }
                }
                .padding(.top, 1)
            }
            .onAppear {
                fetchPosts()
            }
            .navigationTitle("Home")

        }
    }

    private func fetchPosts() {
        guard let currentUser = currentUser else {
            return
        }

        let group = DispatchGroup()

        let apiURLString = "http://localhost:3000/api/posts/feed?followers=\(currentUser.id)&sort=createdAt:desc"

        guard let apiURL = URL(string: apiURLString) else {
            return
        }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let fetchedPosts = try decoder.decode([Post].self, from: data)

                let uniqueUserIDs = Set(fetchedPosts.compactMap { $0.postedBy })

                for userID in uniqueUserIDs {
                    group.enter()
                    fetchUser(for: userID) {
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    DispatchQueue.main.async {
                        self.posts = fetchedPosts
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    private func fetchUser(for userID: String, completion: @escaping () -> Void) {
        guard let apiURL = URL(string: "http://localhost:3000/api/users/profile/\(userID)") else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let user = try decoder.decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    self.users[user.id] = user
                    completion()
                }
            } catch {
                print("Error decoding user JSON: \(error)")
                completion()
            }
        }.resume()
    }
    private func likedPostsBinding(for postId: String) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                self.likedPosts.contains(postId)
            },
            set: { newValue in
                self.updateLikedPosts(postId: postId, isLiked: newValue)
            }
        )
    }
    private func saveLikedPosts() {
        if let data = try? JSONEncoder().encode(likedPosts) {
            UserDefaults.standard.set(data, forKey: "likedPosts")
        }
    }
    private func updateLikedPosts(postId: String, isLiked: Bool) {
        var updatedLikedPosts = self.likedPosts
        saveLikedPosts()
    }

}
struct HeartButton: View {
    var post: Post
    @Binding var likedPosts: Set<String>

    private var isLiked: Bool {
        likedPosts.contains(post.id)
    }
    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }

    var body: some View {
        Button(action: {
            likeUnlikePost(postId: post.id)
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 27)
                .foregroundColor(isLiked ? .red : .black)
        }
    }

    private func likeUnlikePost(postId: String) {
        guard let currentUser = currentUser else {
            return
        }

        let likeUnlikeURL = URL(string: "http://localhost:3000/api/posts/like/\(postId)")!

        let postData: [String: String] = [
            "id": postId,
            "userId": currentUser.id
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: postData) {
            var request = URLRequest(url: likeUnlikeURL)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error liking/unliking post: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                DispatchQueue.main.async {
                    if isLiked {
                        likedPosts.remove(postId)
                    } else {
                        likedPosts.insert(postId)
                    }
                    
                    // Save the updated likedPosts to UserDefaults
                    saveLikedPosts()
                }

            }.resume()
        }
    }
    
    private func saveLikedPosts() {
        do {
               let data = try JSONEncoder().encode(likedPosts)
               UserDefaults.standard.set(data, forKey: "likedPosts")
           } catch {
               print("Error encoding likedPosts: \(error)")
           }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            HomeView()
    }
}
