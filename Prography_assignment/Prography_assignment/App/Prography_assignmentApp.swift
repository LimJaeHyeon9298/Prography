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
    @State var isSplashView = true
    @State var showSplash = true
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
            if isSplashView {
                LaunchScreenView()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                            isSplashView = false
                        }
                    }
            } else {
                MainTabView(container: container)
            }
           
        }
        .modelContainer(sharedModelContainer)
    }
}

struct LaunchScreenView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIStoryboard(name: "Launch Screen", bundle: nil).instantiateInitialViewController()!
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
