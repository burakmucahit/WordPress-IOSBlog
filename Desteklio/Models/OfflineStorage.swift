import Foundation
import SwiftData

@Model
final class OfflinePost {
    let id: Int
    let title: String
    let content: String
    let excerpt: String
    let date: String
    let imageData: Data?
    
    init(post: Post, imageData: Data? = nil) {
        self.id = post.id
        self.title = post.title.rendered
        self.content = post.content.rendered
        self.excerpt = post.excerpt.rendered
        self.date = post.date
        self.imageData = imageData
    }
} 