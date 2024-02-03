//
//  APIMenager.swift
//  ThreadsClone_SwiftUI
//
//  Created by User on 6.1.24..
//

import Foundation

import Foundation

class APIManager {
    static let shared = APIManager()

    func getUserPosts(username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/posts/user/\(username)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -3, userInfo: nil)))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                if let data = data {
                    do {
                        let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                        completion(.success(decodedPosts))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "NoData", code: -2, userInfo: nil)))
                }

            default:
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
}
