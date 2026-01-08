import Foundation
import SwiftUI

// The three search engines
enum SearchScope: String, CaseIterable, Identifiable {
    case movies = "Movies"
    case books = "Books"
    case albums = "Albums"
    
    var id: String { self.rawValue }
    
    var prompt: String {
        "Search \(self.rawValue.lowercased())..."
    }
}

struct LogdMovie: Identifiable {
    let id: Int
    let title: String
    let releaseYear: String
    let posterPath: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }
}
