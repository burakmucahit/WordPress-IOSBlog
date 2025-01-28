import Foundation
import SwiftUI

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var mediaCache: [Int: String] = [:]
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isGridView = true // Grid/Liste görünümü için
    @Published var loadingStates: [Int: Bool] = [:] // Skeleton loading için
    
    private var currentPage = 1
    private var canLoadMore = true
    
    func loadPosts(forceRefresh: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            if !forceRefresh, let cachedData = await CacheManager.shared.getCachedResponse(for: "posts_page_\(currentPage)") {
                let decoder = JSONDecoder()
                posts = try decoder.decode([Post].self, from: cachedData)
            } else {
                let newPosts = try await WordPressService.fetchPosts(page: currentPage)
                posts = newPosts
                if let encodedData = try? JSONEncoder().encode(newPosts) {
                    await CacheManager.shared.cacheResponse(encodedData, for: "posts_page_\(currentPage)")
                }
            }
            await loadMediaForPosts(posts)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoading && canLoadMore else { return }
        
        currentPage += 1
        isLoading = true
        
        do {
            let newPosts = try await WordPressService.fetchPosts(page: currentPage)
            if newPosts.isEmpty {
                canLoadMore = false
            } else {
                posts.append(contentsOf: newPosts)
                await loadMediaForPosts(newPosts)
            }
        } catch {
            self.error = error
            currentPage -= 1
        }
        
        isLoading = false
    }
    
    private func loadMediaForPosts(_ posts: [Post]) async {
        await withTaskGroup(of: Void.self) { group in
            for post in posts {
                if post.featuredMedia > 0 && mediaCache[post.id] == nil {
                    group.addTask {
                        do {
                            let media = try await WordPressService.fetchMedia(id: post.featuredMedia)
                            await MainActor.run {
                                withAnimation {
                                    self.mediaCache[post.id] = media.sourceUrl
                                }
                            }
                        } catch {
                            print("Media loading error for post \(post.id): \(error)")
                            await MainActor.run {
                                self.mediaCache[post.id] = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadCategoryPosts(categoryId: Int) async {
        guard !isLoading else { return }
        currentPage = 1
        isLoading = true
        
        do {
            let newPosts = try await WordPressService.fetchPostsByCategory(categoryId: categoryId, page: currentPage)
            posts = newPosts
            await loadMediaForPosts(newPosts)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func loadMoreCategoryPosts(categoryId: Int) async {
        guard !isLoading && canLoadMore else { return }
        
        currentPage += 1
        isLoading = true
        
        do {
            let newPosts = try await WordPressService.fetchPostsByCategory(categoryId: categoryId, page: currentPage)
            if newPosts.isEmpty {
                canLoadMore = false
            } else {
                posts.append(contentsOf: newPosts)
                await loadMediaForPosts(newPosts)
            }
        } catch {
            self.error = error
            currentPage -= 1
        }
        
        isLoading = false
    }
} 