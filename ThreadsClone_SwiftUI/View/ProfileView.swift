import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var tabIndex: Int = 0
    @State private var isEditProfileActive = false
    @State private var isSettingsVisible = false
    
    private var currentUser: User? {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack (alignment: .leading, spacing: 30) {
                                  HStack {
                                      Image(systemName: "network")
                                          .customFont(.title)
                                          .navigationBarBackButtonHidden(true)
                                      Spacer()
                                      Image(systemName: "button.programmable.square")
                                          .customFont(.title)
                                      NavigationLink(destination: SettingsView(), isActive: $isSettingsVisible) {
                                          EmptyView()
                                      }
                                      Button(action: {
                                          isSettingsVisible = true
                                      }) {
                                          Image(systemName: "text.alignright")
                                              .customFont(.title)
                                      }
                                  }
                                  .foregroundColor(Color("Text"))
                                  
                                  if let currentUser = currentUser {
                                      ProfileDetailsView(user: currentUser, showCount: true)
                                  }
                                  HStack {
                                      
                                      NavigationLink(destination: EditProfileView(), isActive: $isEditProfileActive) {
                                          EmptyView()
                                      }
                                      .hidden()
                                      Button(action: {
                                          isEditProfileActive = true
                                      }) {
                                          Text("Edit profile")
                                      }
                                      .frame(maxWidth: .infinity)
                                      .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                      .customFont(.headline)
                                      .background(Color("Primary"))
                                      .foregroundColor(Color("Text"))
                                      .cornerRadius(10)
                                      .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                                      
                                      Button(action: {}) {
                                          Text("Share profile")
                                      }
                                      .frame(maxWidth: .infinity)
                                      .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                      .customFont(.headline)
                                      .background(Color("Primary"))
                                      .foregroundColor(Color("Text"))
                                      .cornerRadius(10)
                                      .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))

                                  }
                              }
                              .padding(20)

                HStack(spacing: 0) {
                    TabBarButtonView(text: "Threads", isSelected: .constant(tabIndex == 0))
                        .onTapGesture { onButtonTapped(index: 0) }
                    TabBarButtonView(text: "Replies", isSelected: .constant(tabIndex == 1))
                        .onTapGesture { onButtonTapped(index: 1) }
                }
                .padding(20)
                
                if tabIndex == 0 {
                    if viewModel.userPosts.isEmpty {
                        Text("No threads to display.")
                    } else {
                        ForEach(viewModel.userPosts,id: \.self) { post in
                            if let currentUser = currentUser {
                                PostView(user: currentUser, post: post)
                                    .padding(.bottom, 20)
                            } else {
                                Text("User information not available.")
                            }
                        }
                    }
                } else {
                    if viewModel.userPosts.isEmpty {
                        Text("No reply to display.")
                    } else {
                        ForEach(viewModel.userPosts,id: \.self) { post in
                            if let currentUser = currentUser {
                                            ForEach(post.replies, id: \.self) { reply in
                                                ReplyOrNoReplyView(reply: reply, user: currentUser)
                                                    .padding(.bottom, 20)
                                            }
                                        } else {
                                            Text("User information not available.")
                                        }
                        }
                    }
                }
            }
        }
        .padding(.top, 1)
        .onAppear {
            if let currentUserID = currentUser?.username {
                viewModel.fetchUserPosts(username: currentUserID)
            }
        }
    }
    
    private func onButtonTapped(index: Int) {
        tabIndex = index
    }
}
struct ReplyOrNoReplyView: View {
    var reply: Post.Reply?
    var user: User

    var body: some View {
        if let reply = reply {
            ReplyView(reply: reply, user: user)
        } else {
            NoReplyView()
        }
    }
}

struct NoReplyView: View {
    var body: some View {
        Text("No replies available for this post.")
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleViewModel = ProfileViewModel()
        return ProfileView(viewModel: sampleViewModel)
    }
}
