import SwiftUI

struct NumberedSliderView: View {
    let posts: [Post]
    let mediaCache: [Int: String]
    @State private var currentIndex = 0
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    private let maxSlides = 3
    
    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentIndex) {
                ForEach(Array(posts.prefix(maxSlides).enumerated()), id: \.element.id) { index, post in
                    NavigationLink {
                        PostDetailView(post: post, imageURL: mediaCache[post.id])
                    } label: {
                        SlideItemView(post: post, imageURL: mediaCache[post.id])
                    }
                    .tag(index)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: 280)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Dots Indicator
            HStack(spacing: 8) {
                ForEach(0..<min(posts.count, maxSlides), id: \.self) { index in
                    Circle()
                        .fill(currentIndex == index ? ThemeColors.accent : ThemeColors.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.spring(duration: 0.3), value: currentIndex)
                }
            }
            .padding(.bottom, 8)
        }
        .onReceive(timer) { _ in
            withAnimation(.spring(duration: 0.3)) {
                currentIndex = (currentIndex + 1) % min(posts.count, maxSlides)
            }
        }
    }
}

private struct SlideItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let post: Post
    let imageURL: String?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if let imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(.gray.opacity(0.1))
                        .overlay {
                            ProgressView()
                        }
                }
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.1))
            }
            
            // Content Overlay
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title.rendered.htmlToString())
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(post.date.formatDate())
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text("Devamını Oku")
                        .font(.footnote.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [
                        .clear,
                        colorScheme == .dark ? .black.opacity(0.6) : .black.opacity(0.4),
                        .black.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: ThemeColors.text.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    NumberedSliderView(
        posts: [
            Post(id: 1, date: "2024-02-07T12:00:00", title: RenderedContent(rendered: "Test Başlık 1"), content: RenderedContent(rendered: "Test İçerik"), excerpt: RenderedContent(rendered: "Test Özet"), featuredMedia: 0),
            Post(id: 2, date: "2024-02-07T12:00:00", title: RenderedContent(rendered: "Test Başlık 2"), content: RenderedContent(rendered: "Test İçerik"), excerpt: RenderedContent(rendered: "Test Özet"), featuredMedia: 0),
            Post(id: 3, date: "2024-02-07T12:00:00", title: RenderedContent(rendered: "Test Başlık 3"), content: RenderedContent(rendered: "Test İçerik"), excerpt: RenderedContent(rendered: "Test Özet"), featuredMedia: 0)
        ],
        mediaCache: [:]
    )
} 