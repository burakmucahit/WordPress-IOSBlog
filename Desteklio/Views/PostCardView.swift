import SwiftUI

struct PostCardView: View {
    let post: Post
    let imageURL: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL {
                CachedAsyncImage(url: imageURL, contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title.rendered.htmlToString())
                    .font(.headline)
                    .foregroundStyle(ThemeColors.text)
                    .lineLimit(2)
                
                Text(post.excerpt.rendered.htmlToString())
                    .font(.subheadline)
                    .foregroundStyle(ThemeColors.secondary)
                    .lineLimit(3)
                
                HStack {
                    Text(post.date.formatDate())
                        .font(.caption)
                        .foregroundStyle(ThemeColors.secondary)
                    
                    Spacer()
                    
                    Text("Devamını Oku")
                        .font(.caption.bold())
                        .foregroundStyle(ThemeColors.accent)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(ThemeColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: ThemeColors.text.opacity(0.1), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle()) // Bu tüm alanı tıklanabilir yapar
    }
}

#Preview {
    PostCardView(
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