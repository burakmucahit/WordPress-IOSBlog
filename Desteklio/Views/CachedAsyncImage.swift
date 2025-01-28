import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    let contentMode: ContentMode
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                Rectangle()
                    .fill(ThemeColors.cardBackground)
                    .overlay {
                        ProgressView()
                    }
            } else {
                Rectangle()
                    .fill(ThemeColors.cardBackground)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(ThemeColors.secondary)
                    }
            }
        }
        .clipped() // Taşan kısımları kırp
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        // Önbellekten kontrol et
        if let cachedImage = await CacheManager.shared.getImage(for: urlString) {
            image = cachedImage
            isLoading = false
            return
        }
        
        // Yoksa indir
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                await CacheManager.shared.cacheImage(downloadedImage, for: urlString)
                image = downloadedImage
            }
        } catch {
            print("Image loading error: \(error)")
        }
        
        isLoading = false
    }
}

// Önizleme için
#Preview {
    CachedAsyncImage(url: "https://example.com/image.jpg", contentMode: .fill)
} 