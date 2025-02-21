//
//  Prography_assignmentApp.swift
//  Prography_assignment
//
//  Created by 임재현 on 2/17/25.
//

import SwiftUI
import SwiftData

@main
struct Prography_assignmentApp: App {
    
    let container = DIContainer()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MovieReview.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
            DataManager.shared.setModelContext(sharedModelContainer.mainContext)
        }
    
    @State private var selectedTab: TabItem = .home

    var body: some Scene {
        WindowGroup {
            MainTabView(container: container)
        }
        .modelContainer(sharedModelContainer)
    }
}
