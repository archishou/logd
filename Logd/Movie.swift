import Foundation

struct Movie: Identifiable {
    let id: Int
    let title: String
    let releaseYear: String
    let posterPath: String? // URL for the image
    
    // Helper to build the full URL
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}
