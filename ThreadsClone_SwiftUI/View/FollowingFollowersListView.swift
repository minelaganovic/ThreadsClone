import SwiftUI

struct FollowingFollowersListView: View {
    var users: [User]

    var body: some View {
        // Implement the UI to display the list of followers or following
        // You can use a List or ScrollView based on your design
        List(users, id: \.id) { user in
            // Display user information
            HStack {
                AsyncImage(
                    url: URL(string: user.profilePic),
                    content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                    },
                    placeholder: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                    }
                )
                Text(user.name)
            }
        }
        .navigationTitle("Followers / Following")
    }
}
