import SwiftUI

struct LogEntryView: View {
    let media: LogdMedia
    @Environment(\.dismiss) var dismiss
    
    @State private var rating: Int = 0
    @State private var reviewText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Media Identity Bar
                HStack(spacing: 16) {
                    AsyncImage(url: media.imageURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 60, height: 90)
                    .cornerRadius(6)
                    .shadow(radius: 2)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(media.title)
                            .font(.headline)
                            .lineLimit(2)
                        Text(media.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))

                // Interaction Area
                VStack(spacing: 30) {
                    // Star Rating
                    VStack(spacing: 10) {
                        Text(rating == 0 ? "Tap to Rate" : "\(rating) Stars")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        HStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .font(.system(size: 35))
                                    .foregroundColor(index <= rating ? .orange : .gray.opacity(0.3))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                            rating = index
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.top, 30)

                    // Review Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $reviewText)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(12)
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("New Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // DB logic will go here later
                        dismiss()
                    }
                    .bold()
                    .disabled(rating == 0)
                }
            }
        }
    }
}
