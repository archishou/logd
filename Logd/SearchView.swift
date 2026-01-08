import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var selectedScope: SearchScope = .movies
    
    // This allows us to detect if the search bar is active
    @Environment(\.isSearching) private var isSearching
    
    var body: some View {
        NavigationStack {
            Group {
                if searchText.isEmpty {
                    // This is the "Empty State" view
                    ContentUnavailableView(
                        "Find Media",
                        systemImage: "magnifyingglass",
                        description: Text("Search for a movie, book, or album to log it.")
                    )
                } else {
                    List {
                        Text("Results for \(searchText) in \(selectedScope.rawValue)")
                    }
                }
            }
            .navigationTitle("Search")
            // Logic: If user hasn't tapped the bar, show general prompt.
            // Once they tap it, show the specific engine prompt.
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
        }
    }
}

// Keep the Enum outside or in a Models file
enum SearchScope: String, CaseIterable, Identifiable {
    case movies = "Movies"
    case books = "Books"
    case albums = "Albums"
    
    var id: String { self.rawValue }
    
    var prompt: String {
        "Search \(self.rawValue.lowercased())..."
    }
}
