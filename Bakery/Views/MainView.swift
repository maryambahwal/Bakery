import SwiftUI
import  Network
class Reachability: ObservableObject {
        private let monitor = NWPathMonitor()
        private let queue = DispatchQueue(label: "Reachability")
        
        @Published var isConnected: Bool = true
        
        init() {
            monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    self?.isConnected = path.status == .satisfied
                }
            }
            monitor.start(queue: queue)
        }
        
        deinit {
            monitor.cancel()
        }
    }
struct MainView: View {
    @EnvironmentObject var reachability: Reachability // Access Reachability

    var body: some View {
        TabView {
            Home()
            .tabItem {
                Image("Logo 1")
                    .renderingMode(.template)
                Text("Home")
            }

            Courses()
            .tabItem {
                Image("Courses 1")
                    .renderingMode(.template)
                Text("Courses")
            }
            
            Profile()
            .tabItem {
                Image("Profile")
                    .renderingMode(.template)
                Text("Profile")
            }
        }
        .accentColor(.aPrimary)
    }
}

#Preview {
    MainView()
}
