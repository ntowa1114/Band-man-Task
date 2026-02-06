import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            Home()
                .tabItem {
                    Label("曲", systemImage: "music.note.list")
                }

            LiveView()
                .tabItem {
                    Label("ライブ", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(SongMane())
        .environmentObject(LiveMane())
}
