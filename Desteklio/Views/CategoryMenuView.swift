import SwiftUI

struct CategoryMenuView: View {
    @State private var showMenu = false
    @State private var categories: [Category] = []
    @State private var isLoading = false
    @State private var error: Error?
    
    var body: some View {
        Menu {
            if isLoading {
                ProgressView()
            } else {
                // Ana Sayfa seçeneği
                NavigationLink(destination: PostListView(categoryId: -1)) {
                    Label {
                        Text("Ana Sayfa")
                            .foregroundStyle(ThemeColors.text)
                    } icon: {
                        Image(systemName: "house.fill")
                            .foregroundStyle(ThemeColors.accent)
                    }
                }
                
                Divider()
                
                ForEach(categories) { category in
                    NavigationLink(destination: PostListView(categoryId: category.id)) {
                        Label {
                            Text(category.displayName)
                        } icon: {
                            if category.count > 0 {
                                Text("\(category.count)")
                                    .font(.caption2)
                                    .padding(4)
                                    .background(ThemeColors.accent.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "list.bullet")
                .foregroundStyle(ThemeColors.accent)
                .font(.title3)
        }
        .task {
            await loadCategories()
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