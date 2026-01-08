import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.4))
                Text("Search for a movie, book, or album to log it.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Find media...")
        }
    }
}
