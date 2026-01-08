import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Activity", systemImage: "rectangle.stack.person.crop.fill")
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
        .accentColor(.blue) // The primary brand color for your "Logd" app
    }
}

// MARK: - Activity Feed (Twitter-style)
struct FeedView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        FeedItemCard()
                    }
                }
                .padding()
            }
            .navigationTitle("Activity")
            .background(Color(.systemGroupedBackground))
        }
    }
}

// A reusable component for the feed
struct FeedItemCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Username").font(.headline)
                        Text("logged a movie").font(.subheadline).foregroundColor(.secondary)
                    }
                    Text("2 hours ago").font(.caption).foregroundColor(.secondary)
                }
            }
            
            // Media Content Section
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 90) // Poster/Cover aspect ratio
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("The Matrix").font(.title3).bold()
                    Text("★★★★☆").foregroundColor(.orange)
                    Text("This movie is still mind-blowing in 2026. The visuals hold up remarkably well.")
                        .font(.body)
                        .lineLimit(3)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Search View (The "Add" Gateway)
struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // The actual search bar will go here
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.4))
                Text("Search for a movie, book, or album to log it.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Find media...")
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Stats") {
                    HStack {
                        VStack { Text("12").bold(); Text("Movies") }
                        Spacer()
                        VStack { Text("45").bold(); Text("Books") }
                        Spacer()
                        VStack { Text("128").bold(); Text("Albums") }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Recent Logs") {
                    Text("Log history will appear here.")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
