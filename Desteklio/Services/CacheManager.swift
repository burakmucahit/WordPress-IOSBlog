import Foundation
import SwiftUI

actor CacheManager {
    static let shared = CacheManager()
    
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
        return cache
    }()
    
    private var apiCache: NSCache<NSString, CachedResponse> = {
        let cache = NSCache<NSString, CachedResponse>()
        cache.countLimit = 100
        return cache
    }()
    
    // Cache key'lerini takip etmek için
    private var apiCacheKeys: Set<String> = []
    
    func cacheImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    func cacheResponse(_ data: Data, for url: String) {
        let cachedResponse = CachedResponse(data: data, timestamp: Date())
        apiCache.setObject(cachedResponse, forKey: url as NSString)
        apiCacheKeys.insert(url)
    }
    
    func getCachedResponse(for url: String) -> Data? {
        guard let cached = apiCache.object(forKey: url as NSString) else { return nil }
        // Cache'i 1 saat geçerli tut
        if Date().timeIntervalSince(cached.timestamp) > 3600 {
            apiCache.removeObject(forKey: url as NSString)
            apiCacheKeys.remove(url)
            return nil
        }
        return cached.data
    }
    
    // Tüm cache'i temizle
    func clearAllCache() {
        imageCache.removeAllObjects()
        apiCache.removeAllObjects()
        apiCacheKeys.removeAll()
    }
    
    // Sadece resim cache'ini temizle
    func clearImageCache() {
        imageCache.removeAllObjects()
    }
    
    // Sadece API cache'ini temizle
    func clearAPICache() {
        apiCache.removeAllObjects()
        apiCacheKeys.removeAll()
    }
    
    // Belirli bir süre geçmiş cache'leri temizle
    func clearExpiredCache() {
        let expirationInterval: TimeInterval = 3600 * 24 // 24 saat
        
        // API cache'ini kontrol et
        for key in apiCacheKeys {
            if let cached = apiCache.object(forKey: key as NSString),
               Date().timeIntervalSince(cached.timestamp) > expirationInterval {
                apiCache.removeObject(forKey: key as NSString)
                apiCacheKeys.remove(key)
            }
        }
    }
}

final class CachedResponse {
    let data: Data
    let timestamp: Date
    
    init(data: Data, timestamp: Date) {
        self.data = data
        self.timestamp = timestamp
    }
} 