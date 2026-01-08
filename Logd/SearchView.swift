import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .movies
    @StateObject private var movieService = MovieService()
    
    var body: some View {
        NavigationStack {
            Group {
                // Shows a placeholder when not searching
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Find Media",
                        systemImage: "magnifyingglass",
                        description: Text("Search for a movie, book, or album to log it.")
                    )
                } else {
                    // Logic for switching between different media types
                    switch selectedScope {
                    case .movies:
                        movieList
                    case .books:
                        comingSoonView(type: "Books")
                    case .albums:
                        comingSoonView(type: "Albums")
                    }
                }
            }
            .navigationTitle("Search")
            // This restores your searchable bar with the Scope bar (Tabs)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: selectedScope.prompt
            )
            .searchScopes($selectedScope) {
                ForEach(SearchScope.allCases) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .onChange(of: searchText) { _, newValue in
                if selectedScope == .movies {
                    Task { await movieService.searchMovies(query: newValue) }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var movieList: some View {
        List(movieService.results) { movie in
            ZStack {
                // Invisible link to the Detail View
                NavigationLink(destination: MediaDetailView(media: movie)) {
                    EmptyView()
                }
                .opacity(0)
                
                MovieSearchRow(movie: movie)
            }
            .listRowSeparator(.visible)
        }
        .listStyle(.plain)
    }
    
    private func comingSoonView(type: String) -> some View {
        ContentUnavailableView(
            "\(type) Search Coming Soon",
            systemImage: type == "Books" ? "book" : "music.note",
            description: Text("We are currently building the API integration for \(type.lowercased()).")
        )
    }
}

// MARK: - Search Row Component
struct MovieSearchRow: View {
    let movie: LogdMovie
    @State private var showingLogSheet = false

    var body: some View {
        HStack(spacing: 16) {
            // The Quick-Log Button
            Button(action: { showingLogSheet = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .zIndex(1)
            
            // Poster Thumbnail
            AsyncImage(url: movie.imageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 50, height: 75)
            .cornerRadius(4)
            .clipped()
            
            // Title & Year
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(movie.releaseYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingLogSheet) {
            LogEntryView(media: movie)
        }
    }
}
