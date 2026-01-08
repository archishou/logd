import Foundation

class MovieService: ObservableObject {
    @Published var results: [LogdMovie] = []
    
    // PASTE YOUR TMDB READ ACCESS TOKEN HERE
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYmZlYjcwMTNkMjZiMjVmZjY3NjhlYzA4NmEzYTMwNyIsIm5iZiI6MTc2NzgzODAzOS4zNiwic3ViIjoiNjk1ZjExNTc1NTRkYjkzYzY5ODYzOTExIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.V1ilweCDqPrT1Kkw1Fn318joQbXjjMnaXiqJsEM7ReQ"
    
    func searchMovies(query: String) async {
        guard !query.isEmpty else {
            DispatchQueue.main.async { self.results = [] }
            return
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(encodedQuery)&include_adult=false&language=en-US&page=1"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedResponse = try JSONDecoder().decode(TMDBResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.results = decodedResponse.results.map { item in
                    let year = item.release_date.count >= 4 ? String(item.release_date.prefix(4)) : "N/A"
                    
                    // FIXED: Now passing 'overview' into the initializer
                    return LogdMovie(
                        id: item.id,
                        title: item.title,
                        releaseYear: year,
                        posterPath: item.poster_path,
                        overview: item.overview
                    )
                }
            }
        } catch {
            print("Search failed: \(error.localizedDescription)")
        }
    }
}

struct TMDBResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Codable {
    let id: Int
    let title: String
    let release_date: String
    let poster_path: String?
    let overview: String? // Added to the decoding struct
}
