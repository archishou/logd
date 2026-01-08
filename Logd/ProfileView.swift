import SwiftUI

struct ProfileView: View {
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header Section
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Archi")
                                    .font(.title2.bold())
                                Text("@archishmaan")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 20) {
                                StatView(label: "Movies", count: "12")
                                StatView(label: "Books", count: "45")
                                StatView(label: "Albums", count: "128")
                            }
                        }
                    }
                    .padding(.top, 10)

                    Divider()

                    // Favorites Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Favorites")
                            .font(.headline)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            FavoriteItem(color: .blue, icon: "film")
                            FavoriteItem(color: .blue, icon: "film")
                            FavoriteItem(color: .blue, icon: "film")
                            
                            FavoriteItem(color: .green, icon: "book")
                            FavoriteItem(color: .green, icon: "book")
                            FavoriteItem(color: .green, icon: "book")
                            
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

