import SwiftUI

struct FeedItemCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Username").font(.headline)
                        Text("logged a movie").font(.subheadline).foregroundColor(.secondary)
                    }
                    Text("2 hours ago").font(.caption).foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 90)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("The Matrix").font(.title3).bold()
                    Text("★★★★☆").foregroundColor(.orange)
                    Text("This movie is still mind-blowing. The visuals hold up remarkably well.")
                        .font(.body)
                        .lineLimit(3)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct StatView: View {
    let label: String
    let count: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(count).font(.subheadline.bold())
            Text(label).font(.caption2).foregroundColor(.secondary).textCase(.uppercase)
        }
    }
}

struct FavoriteItem: View {
    let color: Color
    let icon: String
    var isSquare: Bool = false
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color.opacity(0.15))
            .aspectRatio(isSquare ? 1.0 : 0.66, contentMode: .fit)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            )
    }
}
