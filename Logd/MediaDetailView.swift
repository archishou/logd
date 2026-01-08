import SwiftUI
import Charts

struct MediaDetailView: View {
    let media: LogdMedia
    @State private var showingLogSheet = false
    
    let distribution = [
        (stars: "1", count: 80), (stars: "2", count: 150),
        (stars: "3", count: 450), (stars: "4", count: 900),
        (stars: "5", count: 600)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 16) {
                    // Uses .imageURL from protocol
                    AsyncImage(url: media.imageURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(media.title).font(.title2.bold())
                        Text(media.subtitle).font(.headline).foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Button(action: { showingLogSheet = true }) {
                                Label("Log", systemImage: "plus").fontWeight(.bold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(media.themeColor)
                            
                            Button(action: {}) { Image(systemName: "heart") }.buttonStyle(.bordered)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("RATING DISTRIBUTION").font(.caption.bold()).foregroundColor(.secondary)
                    Chart {
                        ForEach(distribution, id: \.stars) { item in
                            BarMark(x: .value("Rating", item.stars), y: .value("Users", item.count))
                            .foregroundStyle(media.themeColor.gradient)
                            .cornerRadius(4)
                        }
                    }
                    .frame(height: 120)
                    .chartYAxis(.hidden)
                }
                .padding().background(Color.gray.opacity(0.05)).cornerRadius(12).padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("DESCRIPTION").font(.caption.bold()).foregroundColor(.secondary)
                    Text(media.description).font(.body).lineSpacing(4)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLogSheet) {
            LogEntryView(media: media)
        }
    }
}
