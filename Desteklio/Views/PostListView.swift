import SwiftUI

struct PostListView: View {
    let categoryId: Int
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var viewModel = PostsViewModel()
    @State private var showSideMenu = false
    @State private var showToast = false
    @State private var toastMessage = ""
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Header with Buttons
                        HStack(spacing: 12) {
                            // Menü Butonu
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
                            
                            // Logo
                            Image(colorScheme == .dark ? "1024-nograp-white" : "1024-nograp-color")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 35)
                                .animation(.easeInOut, value: colorScheme)
                            
                            Spacer()
                            
                            // Dark Mode Toggle
                            Button {
                                withAnimation {
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
                            
                            // Grid/Liste toggle
                            Button {
                                withAnimation {
                                    viewModel.isGridView.toggle()
                                }
                            } label: {
                                Image(systemName: viewModel.isGridView ? "list.bullet" : "square.grid.2x2")
                                    .font(.title3)
                                    .foregroundStyle(ThemeColors.accent)
                            }
                            
                            Menu {
                                Button(role: .destructive) {
                                    Task {
                                        await CacheManager.shared.clearAllCache()
                                        await loadData() // Verileri yeniden yükle
                                        toastMessage = "Önbellek temizlendi"
                                        showToast = true
                                    }
                                } label: {
                                    Label("Tüm Önbelleği Temizle", systemImage: "trash")
                                }
                                
                                Button {
                                    Task {
                                        await CacheManager.shared.clearImageCache()
                                        await loadData()
                                        toastMessage = "Resim önbelleği temizlendi"
                                        showToast = true
                                    }
                                } label: {
                                    Label("Resim Önbelleğini Temizle", systemImage: "photo.badge.arrow.down")
                                }
                                
                                Button {
                                    Task {
                                        await CacheManager.shared.clearAPICache()
                                        await loadData()
                                        toastMessage = "API önbelleği temizlendi"
                                        showToast = true
                                    }
                                } label: {
                                    Label("API Önbelleğini Temizle", systemImage: "arrow.triangle.2.circlepath")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
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
                        
                        if viewModel.isLoading && viewModel.posts.isEmpty {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                        } else {
                            VStack(spacing: 16) {
                                // Numbered Slider sadece ana sayfada gösterilsin
                                if !viewModel.posts.isEmpty && categoryId == -1 {
                                    NumberedSliderView(posts: viewModel.posts, mediaCache: viewModel.mediaCache)
                                        .padding(.top, 8)
                                }
                                
                                // Grid/Liste görünümü için
                                let postsToShow = categoryId == -1 ? Array(viewModel.posts.dropFirst(3)) : viewModel.posts
                                
                                if viewModel.isGridView {
                                    LazyVGrid(columns: columns, spacing: 16) {
                                        ForEach(postsToShow) { post in
                                            NavigationLink {
                                                PostDetailView(post: post, imageURL: viewModel.mediaCache[post.id])
                                            } label: {
                                                PostGridItemView(post: post, imageURL: viewModel.mediaCache[post.id])
                                                    .id(post.id)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                } else {
                                    LazyVStack(spacing: 16) {
                                        ForEach(postsToShow) { post in
                                            NavigationLink(destination: PostDetailView(post: post, imageURL: viewModel.mediaCache[post.id])) {
                                                PostCardView(post: post, imageURL: viewModel.mediaCache[post.id])
                                                    .overlay(Color.clear)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                }
                            }
                        }
                    }
                }
                
                // Side Menu
                SideMenuView(isShowing: $showSideMenu)
            }
            .background(ThemeColors.background)
            .refreshable {
                await loadData()
            }
        }
        .task {
            await loadData()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { _ in
            withAnimation {
                // Bu boş animasyon view'ın yeniden çizilmesini sağlar
            }
        }
        .toast(isPresented: $showToast, message: toastMessage)
    }
    
    private func loadData() async {
        if categoryId == -1 {
            await viewModel.loadPosts()
        } else {
            await viewModel.loadCategoryPosts(categoryId: categoryId)
        }
    }
}

#Preview {
    NavigationStack {
        PostListView(categoryId: 1)
    }
}