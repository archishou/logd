import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .movies
    @StateObject private var movieService = MovieService()
    
    // FIXED: Added 'overview: nil' to mock data
    let mockMovies = [
        LogdMovie(id: 1, title: "The Matrix", releaseYear: "1999", posterPath: nil, overview: "A computer hacker learns from mysterious rebels about the true nature of his reality."),
        LogdMovie(id: 2, title: "Inception", releaseYear: "2010", posterPath: nil, overview: nil)
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    ContentUnavailableView(
                        "Find Media",
                        systemImage: "magnifyingglass",
                        description: Text("Search for a movie, book, or album to log it.")
                    )
                } else {
                    List(movieService.results) { movie in
                        ZStack {
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
            }
            .navigationTitle("Search")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: searchText.isEmpty ? "Search media..." : selectedScope.prompt
            )
            .searchScopes($selectedScope) {
                ForEach(SearchScope.allCases) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    await movieService.searchMovies(query: newValue)
                }
            }
        }
    }
}

struct MovieSearchRow: View {
    let movie: LogdMovie
    @State private var showingLogSheet = false

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                showingLogSheet = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .zIndex(1)
            
            if let url = movie.imageURL {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 75)
                .cornerRadius(4)
                .clipped()
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 75)
                    .overlay(Image(systemName: "film").foregroundColor(.gray))
            }
            
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

struct LogEntryView: View {
    let media: LogdMedia
    @Environment(\.dismiss) var dismiss
    @State private var rating: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("How was")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(media.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(.orange)
                            .onTapGesture { rating = index }
                    }
                }
                
                Divider().padding(.horizontal)
                Text("Write a review...").foregroundColor(.secondary.opacity(0.5))
                Spacer()
            }
            .padding()
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.bold()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
