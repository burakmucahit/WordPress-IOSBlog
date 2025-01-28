import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var categories: [Category] = []
    @State private var isLoading = false
    @State private var error: Error?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                if isShowing {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isShowing = false
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        Image(colorScheme == .dark ? "1024-nograp-white" : "1024-nograp-color")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .animation(.easeInOut, value: colorScheme)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    
                    // Ana Sayfa
                    NavigationLink {
                        PostListView(categoryId: -1)
                    } label: {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Ana Sayfa")
                            Spacer()
                        }
                        .foregroundStyle(ThemeColors.text)
                        .padding()
                        .background(ThemeColors.cardBackground)
                    }
                    .padding(.top, 8)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowing = false
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        // Kategoriler
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(categories) { category in
                                    NavigationLink {
                                        PostListView(categoryId: category.id)
                                    } label: {
                                        HStack {
                                            Text(category.displayName)
                                            Spacer()
                                            if category.count > 0 {
                                                Text("\(category.count)")
                                                    .font(.caption)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(ThemeColors.accent.opacity(0.2))
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        .foregroundStyle(ThemeColors.text)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            isShowing = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: min(geometry.size.width * 0.75, 300))
                .background(ThemeColors.background)
                .offset(x: isShowing ? 0 : -geometry.size.width)
                .animation(.easeInOut(duration: 0.3), value: isShowing)
            }
        }
        .task {
            if categories.isEmpty {
                await loadCategories()
            }
        }
    }
    
    private func loadCategories() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            categories = try await WordPressService.fetchCategories()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
} 