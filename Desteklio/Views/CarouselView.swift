import SwiftUI
import Combine // Publishers için gerekli

struct CarouselView: View {
    let posts: [Post]
    let mediaCache: [Int: String]
    @State private var currentIndex = 0
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            CarouselHeaderView(currentIndex: $currentIndex, posts: posts)
                .padding(.top, 8)
            
            CarouselSliderView(currentIndex: $currentIndex, posts: posts, mediaCache: mediaCache, timer: timer)
                .padding(.vertical, 8)
        }
    }
}

// MARK: - Header View
private struct CarouselHeaderView: View {
    @Binding var currentIndex: Int
    let posts: [Post]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(Array(posts.prefix(3).enumerated()), id: \.element.id) { index, post in
                        CarouselHeaderItem(post: post, isSelected: currentIndex == index)
                            .id(index)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3)) {
                                    currentIndex = index
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: currentIndex) { oldValue, newValue in
                withAnimation(.spring(duration: 0.3)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Header Item
private struct CarouselHeaderItem: View {
    let post: Post
    let isSelected: Bool
    
    var body: some View {
        Text(post.title.rendered.htmlToString())
            .font(.subheadline.weight(isSelected ? .bold : .regular))
            .lineLimit(1)
            .foregroundStyle(isSelected ? Color.primary : Color.secondary)
            .opacity(isSelected ? 1 : 0.7)
            .padding(.vertical, 12)
            .overlay(
                VStack(spacing: 0) {
                    Spacer()
                    Rectangle()
                        .frame(height: 3)
                        .foregroundStyle(isSelected ? Color.blue : Color.clear)
                }
            )
    }
}

// MARK: - Slider View
private struct CarouselSliderView: View {
    @Binding var currentIndex: Int
    let posts: [Post]
    let mediaCache: [Int: String]
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(posts.prefix(3).enumerated()), id: \.element.id) { index, post in
                NavigationLink {
                    PostDetailView(post: post, imageURL: mediaCache[post.id])
                } label: {
                    CarouselItemView(post: post, imageURL: mediaCache[post.id])
                }
                .tag(index)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 250)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onReceive(timer) { _ in
            withAnimation(.spring(duration: 0.3)) {
                currentIndex = (currentIndex + 1) % min(posts.count, 3)
            }
        }
    }
}

// MARK: - Item View
struct CarouselItemView: View {
    let post: Post
    let imageURL: String?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            carouselImage
            contentOverlay
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 16)
    }
    
    private var carouselImage: some View {
        Group {
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
        }
    }
    
    private var contentOverlay: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [
                    .clear,
                    .black.opacity(0.3),
                    .black.opacity(0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title.rendered.htmlToString())
                    .font(.headline)
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
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                }
            }
            .padding(12)
            .background(Color.black.opacity(0.3))
        }
    }
} 