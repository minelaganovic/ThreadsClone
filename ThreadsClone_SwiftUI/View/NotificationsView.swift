import SwiftUI

struct NotificationsView: View {
    @ObservedObject var userViewModel = UserViewModel()
       
       private var currentUser: User? {
           if let userData = UserDefaults.standard.data(forKey: "currentUser"),
              let user = try? JSONDecoder().decode(User.self, from: userData) {
               return user
           }
           return nil
       }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(spacing: 10) {
                                        Button(action: {}) {
                                            Text("All")
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                        .customFont(.headline)
                                        .background(Color("Text"))
                                        .foregroundColor(Color("Primary"))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                                        .navigationBarBackButtonHidden(true)
                                        Button(action: {}) {
                                            Text("Follows")
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                        .customFont(.headline)
                                        .background(Color("Primary"))
                                        .foregroundColor(Color("Text"))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                                        
                                        Button(action: {}) {
                                            Text("Verified")
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                                        .customFont(.headline)
                                        .background(Color("Primary"))
                                        .foregroundColor(Color("Text"))
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                                    }
                                    .padding(20)
            
                                VStack(spacing: 20) {
                                    ForEach(userViewModel.followers) { follower in
                                        NotificationView(user: follower, userViewModel: userViewModel)
                                    }
                                } .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                
                List(userViewModel.followers, id: \.id) { follower in
                    NotificationView(user: follower, userViewModel: userViewModel)
                }
          VStack(spacing: 20) {
        ForEach(userViewModel.following) { followingUser in
                                        NotificationView(user: followingUser, userViewModel: userViewModel)
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            .padding(.top, 1)
        }
        .onAppear {
            guard let currentUser = self.currentUser else {
                return
            }

            // Provera da li su podaci već dohvaćeni
            if userViewModel.followers.isEmpty || userViewModel.following.isEmpty {
                userViewModel.fetchFollowers(for: currentUser.id)
                userViewModel.fetchFollowing(for: currentUser.id)

                print("Followers count: \(userViewModel.followers.count)")
                print("Following count: \(userViewModel.following.count)")

                if !userViewModel.alertMessage.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Prikazivanje obaveštenja
                        userViewModel.isShowingAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $userViewModel.isShowingAlert) {
                    Alert(title: Text("Obaveštenje"), message: Text(userViewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
        
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
