import Foundation

struct WordPressService {
    private enum API {
        static let baseURL = "https://xxx.com/wp-json/wp/v2"
        
        enum Endpoints {
            static let posts = "/posts"
            static let media = "/media"
            static let categories = "/categories"
            static let tags = "/tags"
        }
        
        static func mediaURL(id: Int) -> String {
            return "\(baseURL)\(Endpoints.media)/\(id)"
        }
        
        static func postsURL(page: Int = 1, perPage: Int = 20) -> String {
            return "\(baseURL)\(Endpoints.posts)?page=\(page)&per_page=\(perPage)&_embed=true"
        }
        
        static func categoryPostsURL(categoryId: Int, page: Int = 1, perPage: Int = 20) -> String {
            return "\(baseURL)\(Endpoints.posts)?categories=\(categoryId)&page=\(page)&per_page=\(perPage)&_embed=true"
        }
        
        static func searchPostsURL(query: String, page: Int = 1, perPage: Int = 20) -> String {
            return "\(baseURL)\(Endpoints.posts)?search=\(query)&page=\(page)&per_page=\(perPage)&_embed=true"
        }
        
        static func categoriesURL() -> String {
            return "\(baseURL)\(Endpoints.categories)"
        }
    }
    
    static func fetchPosts(page: Int = 1) async throws -> [Post] {
        guard let url = URL(string: API.postsURL(page: page)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    static func fetchMedia(id: Int) async throws -> Media {
        guard let url = URL(string: API.mediaURL(id: id)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Media.self, from: data)
    }
    
    static func fetchPostsByCategory(categoryId: Int, page: Int = 1) async throws -> [Post] {
        guard let url = URL(string: API.categoryPostsURL(categoryId: categoryId, page: page)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    static func searchPosts(query: String, page: Int = 1) async throws -> [Post] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: API.searchPostsURL(query: encodedQuery, page: page)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }
    
    static func fetchCategories() async throws -> [Category] {
        guard let url = URL(string: API.categoriesURL()) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Category].self, from: data)
    }
} 