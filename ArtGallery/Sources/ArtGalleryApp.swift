import SwiftUI

enum Route: Hashable {
    case detail(gallery: Gallery, imageUrl: String)
}
class NavigationState: ObservableObject {
    @Published var routes: [Route] = []
}

@main
struct ArtGalleryApp: App {
    @StateObject private var navigationState = NavigationState()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            NavigationStack(path: $navigationState.routes) {
                TabView {
                    ForEach(GalleryTab.allCases) { tab in
                        tab.screen
                            .tag(tab as GalleryTab)
                            .tabItem { tab.label }
                            .toolbarBackground(Color.red, for: .tabBar)
                            .toolbarBackground(.visible, for: .tabBar)
                    }
                }
                .tint(.white)
                .environmentObject(navigationState)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                        case .detail(let gallery, let imageUrl):
                        DetailScreen(galleryInfo: gallery, imageUrl: imageUrl)
                    }
                }
                                   
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
