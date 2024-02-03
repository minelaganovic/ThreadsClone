import SwiftUI
import Combine

struct Post: Identifiable, Codable, Hashable{
    var id: String
    let postedBy: String
    let text: String?
    let img: String?
    var likes: [String]
    var replies: [Reply]
    var isLiked: Bool?
    var likesCount: Int {
        return likes.count
    }
    var repliesCount: Int {
        return replies.count
    }
   
    struct Reply:  Codable, Identifiable, Hashable  {
        let id = UUID()
        let userId: String
        let text: String
        let userProfilePic: String?
        let username: String?
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case postedBy
        case text
        case img
        case likes
        case replies
        case isLiked
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        // Compare the properties that uniquely identify a Post
        return lhs.id == rhs.id
            && lhs.postedBy == rhs.postedBy
            && lhs.text == rhs.text
            && lhs.img == rhs.img
        // Compare other properties as needed
    }

    func hash(into hasher: inout Hasher) {
        // Use a unique identifier or hash the properties that uniquely identify a Post
        // For simplicity, using the id property
        hasher.combine(id)
        hasher.combine(postedBy)
        hasher.combine(text)
        // Add other properties as needed
    }
    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
    }
    
}
