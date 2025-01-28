//
//  DesteklioApp.swift
//  Desteklio
//
//  Created by Muco on 28.01.2025.
//

import SwiftUI
import SwiftData

@main
struct DesteklioApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PostListView(categoryId: -1)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
