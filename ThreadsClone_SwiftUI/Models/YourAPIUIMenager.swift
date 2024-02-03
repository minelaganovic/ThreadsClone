//
//  YourAPIUIMenager.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 3.1.24..
//

import Foundation
import Combine

class YourAPIManager {
    static func loginUser(username: String, password: String) -> AnyPublisher<User, Error> {

        let url = URL(string: "http://localhost:3000/api/users/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


