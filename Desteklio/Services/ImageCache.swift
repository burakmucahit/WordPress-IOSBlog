import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Cache boyut limitleri
        cache.countLimit = 100 // Maximum görüntü sayısı
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB limit
    }
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
} 