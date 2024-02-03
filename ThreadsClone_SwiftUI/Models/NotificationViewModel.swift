//
//  NotificationViewModel.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 15.1.24..
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []

    func fetchNotifications() {
        guard let url = URL(string: "http://localhost:3000/api/notifications") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching notifications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedNotifications = try JSONDecoder().decode([Notification].self, from: data)
                DispatchQueue.main.async {
                    self.notifications = decodedNotifications
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

