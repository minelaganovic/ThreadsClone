//
//  UserViewModel.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 15.1.24..
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var followers: [User] = []
    @Published var following: [User] = []
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""

    
   /* func fetchFollowers(for userId: String) {
        guard let url = URL(string: "http://localhost:3000/api/users/followers/\(userId)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching followers: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                    let decodedFollowers = try JSONDecoder().decode([User].self, from: data)
                    
                    let filteredFollowers = decodedFollowers.filter { follower in
                        !self.following.contains { $0.id == follower.id }
                    }

                    DispatchQueue.main.async {
                        print("Fetched followers: \(filteredFollowers)")
                        self.followers = filteredFollowers
                    }
                } catch {
                    print("Error decoding followers JSON: \(error.localizedDescription)")
                }
        }.resume()
    }*/
    func fetchFollowers(for userId: String) {
        guard let url = URL(string: "http://localhost:3000/api/users/followers/\(userId)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching followers: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedFollowers = try JSONDecoder().decode([User].self, from: data)

                DispatchQueue.main.async {
                    // Filtriraj pratioce koji već postoje u listi following
                    let filteredFollowers = decodedFollowers.filter { follower in
                        !self.following.contains { $0.id == follower.id }
                    }

                    print("Fetched followers: \(filteredFollowers)")
                    self.followers = filteredFollowers
                }
            } catch {
                print("Error decoding followers JSON: \(error.localizedDescription)")
            }
        }.resume()
    }


    func fetchFollowing(for userId: String) {
        guard let url = URL(string: "http://localhost:3000/api/users/following/\(userId)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching following: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                    let decodedFollowing = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        print("Fetched following: \(decodedFollowing)")
                        self.following = decodedFollowing
                    }
                } catch {
                    print("Error decoding following JSON: \(error.localizedDescription)")
                }
        }.resume()
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
                    let responseJSON = try JSONDecoder().decode([String: String].self, from: data)
                    print(responseJSON)

                    // Check if the response contains a message
                    if let message = responseJSON["message"] {
                        self.showAlert(message)
                    }

                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }
        .resume()
    }
    func showAlert(_ message: String) {
        self.alertMessage = message
        self.isShowingAlert = true
    }

}

