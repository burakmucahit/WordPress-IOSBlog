import SwiftUI

struct PostGridItemView: View {
    let post: Post
    let imageURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Container
            ZStack {
                if let imageURL {
                    CachedAsyncImage(url: imageURL, contentMode: .fill)
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .clipped() // Taşan kısımları kırp
                } else {
                    Rectangle()
                        .fill(ThemeColors.cardBackground)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(ThemeColors.secondary)
                        }
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Title
            Text(post.title.rendered.htmlToString())
                .font(.subheadline.bold())
                .foregroundStyle(ThemeColors.text)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Date
            Text(post.date.formatDate())
                .font(.caption2)
                .foregroundStyle(ThemeColors.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(ThemeColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: ThemeColors.text.opacity(0.1), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
    }
}

#Preview {
    PostGridItemView(
        post: Post(
            id: 1,
            date: "2024-02-07T12:00:00",
            title: RenderedContent(rendered: "Test Başlık"),
            content: RenderedContent(rendered: "Test İçerik"),
            excerpt: RenderedContent(rendered: "Test Özet"),
            featuredMedia: 0
        ),
        imageURL: nil
    )
    .padding()
} 