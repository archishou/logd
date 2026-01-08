import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        FeedItemCard()
                    }
                }
                .padding()
            }
            .navigationTitle("Activity")
            .background(Color(.systemGroupedBackground))
        }
    }
}
