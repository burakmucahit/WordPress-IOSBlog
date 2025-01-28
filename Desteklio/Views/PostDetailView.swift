import SwiftUI

struct PostDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showShareSheet = false
    @State private var showSideMenu = false
    
    let post: Post
    let imageURL: String?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with Buttons
                HStack(spacing: 12) {
                    // Logo
                    Image(colorScheme == .dark ? "1024-nograp-white" : "1024-nograp-color")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 35)
                        .animation(.easeInOut(duration: 0.2), value: colorScheme)
                    
                    Spacer()
                    
                    // Dark Mode Toggle
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isDarkMode.toggle()
                        }
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(isDarkMode ? .yellow : .primary)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(ThemeColors.cardBackground)
                                    .shadow(color: ThemeColors.text.opacity(0.1), radius: 3, x: 0, y: 1)
                            )
                    }
                    
                    // Menu Button
                    Button {
                        withAnimation(.spring()) {
                            showSideMenu.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title3)
                            .foregroundStyle(ThemeColors.accent)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(ThemeColors.cardBackground)
                                    .shadow(color: ThemeColors.text.opacity(0.1), radius: 3, x: 0, y: 1)
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(ThemeColors.background)
                
                // Content ScrollView
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero Image
                        if let imageURL {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .foregroundStyle(ThemeColors.cardBackground)
                                    .overlay {
                                        ProgressView()
                                    }
                            }
                            .frame(height: 250)
                            .clipShape(Rectangle())
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Date & Reading Time
                            HStack {
                                Label {
                                    Text(post.date.formatDate())
                                        .font(.footnote)
                                } icon: {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(ThemeColors.accent)
                                }
                                
                                Spacer()
                                
                                Label {
                                    Text(estimatedReadingTime(for: post.content.rendered))
                                        .font(.footnote)
                                } icon: {
                                    Image(systemName: "clock")
                                        .foregroundStyle(ThemeColors.accent)
                                }
                            }
                            .foregroundStyle(ThemeColors.secondary)
                            .padding(.top, 16)
                            
                            // Title
                            Text(post.title.rendered.htmlToString())
                                .font(.title2.bold())
                                .foregroundStyle(ThemeColors.text)
                            
                            // Content
                            Text(post.content.rendered.htmlToString())
                                .font(.body)
                                .foregroundStyle(ThemeColors.text)
                                .lineSpacing(8)
                            
                            // Action Buttons
                            HStack(spacing: 12) {
                                // Share Button
                                Button {
                                    showShareSheet = true
                                } label: {
                                    Label("Paylaş", systemImage: "square.and.arrow.up")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .background(ThemeColors.accent)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding(.top, 24)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
            
            SideMenuView(isShowing: $showSideMenu)
                .zIndex(1)
        }
        .background(ThemeColors.background)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                // Bu boş animasyon view'ın yeniden çizilmesini sağlar
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = URL(string: "https://xxx.com/?p=\(post.id)") {
                ShareSheet(items: [url])
            }
        }
    }
    
    private func estimatedReadingTime(for text: String) -> String {
        let wordsCount = text.htmlToString().split(separator: " ").count
        let readingTime = Double(wordsCount) / 200.0
        return "\(max(1, Int(ceil(readingTime)))) dk okuma"
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        PostDetailView(
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
    }
} 