import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .movies
    @StateObject private var movieService = MovieService()
    
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
                        MovieSearchRow(movie: movie)
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
            // Updated iOS 17+ Syntax
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    await movieService.searchMovies(query: newValue)
                }
            }
        }
    }
}

// MARK: - Movie Row Component
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
            
            if let url = movie.posterURL {
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
            LogEntryView(movie: movie)
        }
    }
}

// MARK: - Log Entry View
struct LogEntryView: View {
    let movie: LogdMovie
    @Environment(\.dismiss) var dismiss
    @State private var rating: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("How was")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(movie.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .font(.title)
                            .foregroundColor(.orange)
                            .onTapGesture {
                                rating = index
                            }
                    }
                }
                
                Divider()
                    .padding(.horizontal)
                
                Text("Write a review...")
                    .font(.body)
                    .foregroundColor(.secondary.opacity(0.5))
                
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
