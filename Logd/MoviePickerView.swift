import SwiftUI

struct MoviePickerView: View {
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
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                            .frame(width: 40, height: 60)
                            .cornerRadius(4)
                            .clipped()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(movie.releaseYear)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select a Favorite")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search movies...")
            .onChange(of: searchText) { _, newValue in
                Task {
                    await movieService.searchMovies(query: newValue)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
