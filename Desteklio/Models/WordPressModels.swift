import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let date: String
    let title: RenderedContent
    let content: RenderedContent
    let excerpt: RenderedContent
    let featuredMedia: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        case content
        case excerpt
        case featuredMedia = "featured_media"
    }
}

struct RenderedContent: Codable {
    let rendered: String
    
    enum CodingKeys: String, CodingKey {
        case rendered
    }
}

struct Media: Codable, Identifiable {
    let id: Int
    let sourceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sourceUrl = "source_url"
    }
}

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    let slug: String
    let count: Int
    
    var displayName: String {
        // Türkçe karakter düzeltmeleri
        name.replacingOccurrences(of: "\\u0131", with: "ı")
            .replacingOccurrences(of: "\\u011f", with: "ğ")
    }
} 