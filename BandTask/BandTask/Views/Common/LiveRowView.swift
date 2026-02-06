import SwiftUI

struct LiveRowView: View {
    let live: Live
    let onEdit: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(live.bandName)
                    .font(.headline)
                Text(live.date.formatted(date: .numeric, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button("編集", action: onEdit)
                .buttonStyle(.bordered)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
