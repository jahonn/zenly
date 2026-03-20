import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            ChatView()
                .tabItem {
                    Label("AI Chat", systemImage: "message.fill")
                }
                .tag(1)
            
            MeditationView()
                .tabItem {
                    Label("Meditate", systemImage: "brain.head.profile")
                }
                .tag(2)
            
            TrendsView()
                .tabItem {
                    Label("Trends", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(Color.Theme.primary)
    }
}

#Preview {
    ContentView()
}
