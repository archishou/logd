import Foundation
import SwiftUI

protocol LogdMedia {
    var id: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var description: String { get }
    var imageURL: URL? { get }
    var themeColor: Color { get }
}

struct LogdMovie: Identifiable, Codable, Equatable, LogdMedia {
    let id: Int
    let title: String
    let releaseYear: String
    let posterPath: String?
    let overview: String?
    
    var subtitle: String { releaseYear }
    var description: String { overview ?? "No description available." }
    var themeColor: Color { .blue }
    var imageURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

enum SearchScope: String, CaseIterable, Identifiable {
    case movies = "Movies"
    case books = "Books"
    case albums = "Albums"
    
    var id: String { self.rawValue }
    var prompt: String { "Search \(self.rawValue.lowercased())..." }
    
    // Helper to get the icon for the favorite slots
    var iconName: String {
        switch self {
        case .movies: return "film"
        case .books: return "book"
        case .albums: return "music.note"
        }
    }
}
