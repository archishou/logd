import SwiftUI

struct ProfileView: View {
    @AppStorage("favorites") var favoritesData: Data = Data()
    @State private var showingSearch = false
    @State private var selectedSlotIndex: Int? = nil
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var favorites: [LogdMovie?] {
        let decoded = try? JSONDecoder().decode([LogdMovie?].self, from: favoritesData)
        return decoded ?? Array(repeating: nil, count: 9)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 24) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray.opacity(0.3))
                            
                            HStack(spacing: 24) {
                                ProfileSocialItem(label: "Followers", count: "1.2k")
                                ProfileSocialItem(label: "Following", count: "842")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Archi").font(.title3.bold())
                            Text("@archishmaan").font(.subheadline).foregroundColor(.secondary)
                        }
                        
                        HStack {
                            ProfileMediaItem(label: "Movies", count: "12")
                            Spacer()
                            ProfileMediaItem(label: "Books", count: "45")
                            Spacer()
                            ProfileMediaItem(label: "Albums", count: "128")
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.top, 10)

                    Divider()

                    // MARK: - Favorites Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Favorites").font(.headline)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(0..<9, id: \.self) { index in
                                // Pass the index here so the slot knows which icon to show
                                ProfileFavoriteSlot(
                                    movie: index < favorites.count ? favorites[index] : nil,
                                    scope: scope(for: index) // Pass the actual scope object
                                )
                                .onTapGesture {
                                    selectedSlotIndex = index
                                    showingSearch = true
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSearch) {
                // Using the specific picker for this view
                ProfileMoviePicker(onSelect: { selectedMovie in
                    saveMovie(selectedMovie, at: selectedSlotIndex ?? 0)
                })
            }
        }
    }
    
    func saveMovie(_ movie: LogdMovie, at index: Int) {
        var currentFavs = favorites
        if currentFavs.count < 9 { currentFavs = Array(repeating: nil, count: 9) }
        currentFavs[index] = movie
        if let encoded = try? JSONEncoder().encode(currentFavs) {
            favoritesData = encoded
        }
    }
}

// MARK: - Private Subcomponents (Renamed to avoid clashing)

struct ProfileSocialItem: View {
    let label: String
    let count: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(count).font(.headline)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}

struct ProfileMediaItem: View {
    let label: String
    let count: String
    var body: some View {
        VStack(spacing: 2) {
            Text(count).font(.subheadline.bold())
            Text(label).font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary).textCase(.uppercase)
        }
    }
}

func scope(for index: Int) -> SearchScope {
    if index < 3 { return .movies }
    if index < 6 { return .albums }
    return .books
}

struct ProfileFavoriteSlot: View {
    let movie: LogdMovie?
    let scope: SearchScope // Reusing our existing Enum
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Poster / Placeholder logic...
            Group {
                if let movie = movie, let url = movie.imageURL {
                    AsyncImage(url: url) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { Color.gray.opacity(0.2) }
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .overlay(Image(systemName: "plus").foregroundColor(.secondary))
                }
            }
            .aspectRatio(0.66, contentMode: .fit)
            .cornerRadius(8).clipped()
            
            // Icon using the helper we added to the Enum
            Image(systemName: scope.iconName)
                .font(.system(size: 10, weight: .bold))
                .padding(5)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .padding(6)
        }
    }
}

struct ProfileMoviePicker: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @StateObject private var movieService = MovieService()
    var onSelect: (LogdMovie) -> Void
    
    var body: some View {
        NavigationStack {
            List(movieService.results) { movie in
                Button {
                    onSelect(movie)
                    dismiss()
                } label: {
                    HStack(spacing: 16) {
                        if let url = movie.imageURL {
                            AsyncImage(url: url) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: { Color.gray.opacity(0.1) }
                            .frame(width: 40, height: 60).cornerRadius(4).clipped()
                        }
                        VStack(alignment: .leading) {
                            Text(movie.title).font(.headline).foregroundColor(.primary)
                            Text(movie.releaseYear).font(.subheadline).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select a Favorite")
            .searchable(text: $searchText, prompt: "Search movies...")
            .onChange(of: searchText) { _, newValue in
                Task { await movieService.searchMovies(query: newValue) }
            }
        }
    }
}
