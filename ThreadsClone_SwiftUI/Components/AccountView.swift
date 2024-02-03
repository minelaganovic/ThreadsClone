//
//  AccountView.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 19.12.23..
//

import SwiftUI

struct AccountView: View {
    var user: User
    
    @State private var followed: Bool = false
    @State private var showNotification: Bool = false

        
        var body: some View {
            HStack(alignment: .top) {
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
                   // NavigationLink(destination: FollowerView(user: user)) {
                                    Text(user.username)
                                        .customFont(.title3)
                         //       }
                    Text(user.name)
                        .customFont(.headline)
                }
                
                Spacer()
                
                Button(action: {
                    // Toggle the followed state
                    followed.toggle()
                    
                    // Perform the follow/unfollow API request
                    followUnfollowUser(user_id: user.id, id: user.id)
                    
                    showNotification = true
                }) {
                    Text(followed == false ? "Follow" : "Unfollow")
                }
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .customFont(.headline)
                .background(Color(followed == false ? "Primary" : "Text"))
                .foregroundColor(Color(followed == false ? "Text" : "Primary"))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke().fill(Color("Text").opacity(0.5)))
                .alert(isPresented: $showNotification) {
                                Alert(title: Text("Notification"), message: Text("User \(user.username) \(followed ? "followed" : "unfollowed") you."), dismissButton: .default(Text("OK")))
                            }
            }
        }
    }

    func followUnfollowUser(user_id: String, id: String) {
        guard let url = URL(string: "http://localhost:3000/api/users/follow/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the JSON data
        let json: [String: Any] = [
            "user_id": user_id,
            "id": id
        ]

        do {
            // Convert the JSON data to a Data object
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

            // Attach the JSON data to the request
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }

        // Create a URLSession task for the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Process the response data, if needed
            if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(responseJSON)
                    // You can process the response here if needed
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        .resume()
    }

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(user: UserList.Users[0])
    }
}
