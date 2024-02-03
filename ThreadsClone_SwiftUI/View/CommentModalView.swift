import SwiftUI

struct CommentModalView: View {
    @Binding var isPresented: Bool
    @State private var commentText: String = ""
    var posts: [Post]
    var selectedPost: Post?
    @State private var isCommentPosted: Bool = false
    @State private var postError: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var redirectToHome: Bool = false
    
    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }

    var body: some View {
        Text("")
            .font(.footnote)
            .foregroundColor(Color("Text"))
            .fontWeight(.semibold)
            .navigationBarBackButtonHidden(true)
        NavigationView {
            VStack {
                if let selectedPost = selectedPost {
                    Text(selectedPost.text ?? "")
                        .font(.footnote)
                    
                    AsyncImage(
                        url: URL(string: selectedPost.img ?? ""),
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        }, placeholder: {
                            Rectangle()
                                .foregroundColor(Color("Gray").opacity(0.2))
                                .frame(height: 200)
                        }
                    )
                    
                    HStack {
                        /*Text("Replying to: \(selectedPost.postedBy ?? "")")
                            .font(.footnote)
                            .foregroundColor(Color("Text"))
                            .fontWeight(.semibold)
                        Text("postid to: \(selectedPost.id ?? "")")
                            .font(.footnote)
                            .foregroundColor(Color("Text"))
                            .fontWeight(.semibold)*/
                        Spacer()
                    }
                    .padding(.trailing, 5)
                }
                
                HStack(spacing: 5) {
                    AsyncImage(
                        url: URL(string: currentUser?.profilePic ?? ""),
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
                    
                    VStack(alignment: .leading) {
                        Text(currentUser?.username ?? "")
                            .fontWeight(.semibold)
                            .font(.footnote)
                    }
                    
                    TextField("Enter your comment", text: $commentText)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer() // Add spacer to push content to the top
                NavigationLink(destination: ThreadsRootView(), isActive: $redirectToHome) { EmptyView() }

                Button("Post Comment") {
                    //replypostComment()
                    postComment()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK")) {
                                    redirectToHome = true
                                }
                    )
                }
            }
            .padding()
            .navigationBarItems(
                trailing: cancelButton
            )

        }
    }
    private var cancelButton: some View {
           Button("Cancel") {
               presentationMode.wrappedValue.dismiss()
               redirectToHome = true
           }
       }
    private func replypostComment() {
        showAlert = true
        alertMessage = "Comment posted successfully"
    }
    private func postComment() {
        guard let currentUser = currentUser else {
            print("Error: Current user is nil")
            return
        }

        let postId: String
       if let selectedPostId = selectedPost?.id {
           postId = selectedPostId
        } else {
            postId = "'65b8cccc520b03ee0e51eeb2'"
        }

        print("Post ID:", postId)

        let apiUrl = "http://localhost:3000/api/posts/reply/\(postId)"
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let commentData: [String: Any] = [
            "text": commentText
        ]

        print("Comment Data:", commentData)

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: commentData)
        } catch {
            postError = "Error encoding comment data"
            print("Encoding Error:", error.localizedDescription)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                postError = "Error posting comment: \(error.localizedDescription)"
                print("Post Error:", postError ?? "Unknown error")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                postError = "Invalid response from the server"
                print("Invalid response from the server")
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                // Ako je odgovor u okviru uspešnog opsega
                isCommentPosted = true
                showAlert = true
                alertMessage = "Comment posted successfully"
                print("Comment posted successfully")
            } else {
                // Ako je došlo do greške
                postError = "Error posting comment: Unexpected HTTP status code \(httpResponse.statusCode)"
                showAlert = true
                alertMessage = postError ?? "An error occurred"
                print("Error posting comment:", postError ?? "Unknown error")
            }
        }.resume()
    }

}

struct CommentModalView_Previews: PreviewProvider {
    static var previews: some View {
        CommentModalView(isPresented: .constant(true), posts: [])
    }
}
