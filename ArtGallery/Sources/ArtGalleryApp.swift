import SwiftUI

@main
struct ArtGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
            NavigationStack {
                TabView {
                    ForEach(GalleryTab.allCases) { tab in
                        tab.screen
                            .tag(tab as GalleryTab)
                            .tabItem { tab.label }
                            .toolbarBackground(Color.red, for: .tabBar)
                            .toolbarBackground(.visible, for: .tabBar)
                    }
                }.tint(.white)
            }
        }
    }
}

enum GalleryTab: CaseIterable, Hashable, Identifiable {
    var id: GalleryTab { self }
    case home
    case saved
}

extension GalleryTab {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house").background(.white)
        case .saved:
            Label("Saved", systemImage: "download")
        }
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .home:
            HomeScreen()
        case .saved:
            Text("Saved")
        }
    }
}
