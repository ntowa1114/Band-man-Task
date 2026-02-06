import SwiftUI

@main
struct BandTaskApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(SongMane())
                .environmentObject(LiveMane())
        }
    }
}
