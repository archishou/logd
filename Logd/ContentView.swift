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

import SwiftUI

struct ProfileView: View {
    // Define a 3-column layout for the Favorites grid
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header Section
                    HStack(alignment: .center, spacing: 20) {
                        // Profile Picture
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.3))
                            .clipShape(Circle())
                        
                        // Name and Stats Group
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Archi")
                                    .font(.title2.bold())
                                Text("@archishmaan")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Compact Stats Row
                            HStack(spacing: 20) {
                                StatView(label: "Movies", count: "12")
                                StatView(label: "Books", count: "45")
                                StatView(label: "Albums", count: "128")
                            }
                        }
                    }
                    .padding(.top, 10)

                    Divider()

                    // MARK: - Favorites Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Favorites")
                            .font(.headline)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Row 1: Movies (Tall)
                            FavoriteItem(color: .blue, icon: "film")
                            FavoriteItem(color: .blue, icon: "film")
                            FavoriteItem(color: .blue, icon: "film")
                            
                            // Row 2: Books (Tall)
                            FavoriteItem(color: .green, icon: "book")
                            FavoriteItem(color: .green, icon: "book")
                            FavoriteItem(color: .green, icon: "book")
                            
                            // Row 3: Albums (Square)
                            FavoriteItem(color: .purple, icon: "music.note", isSquare: true)
                            FavoriteItem(color: .purple, icon: "music.note", isSquare: true)
                            FavoriteItem(color: .purple, icon: "music.note", isSquare: true)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile").font(.headline)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatView: View {
    let label: String
    let count: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(count)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
    }
}

struct FavoriteItem: View {
    let color: Color
    let icon: String
    var isSquare: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.opacity(0.15))
            // 0.66 ratio for posters/books, 1.0 for album squares
            .aspectRatio(isSquare ? 1.0 : 0.66, contentMode: .fit)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            )
    }
}
