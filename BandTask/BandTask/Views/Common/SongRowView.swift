import SwiftUI

struct SongRowView: View {
    let song: Song
    let onEdit: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(song.songname)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(song.artist)
                    Text("–")
                    Text(song.inst.isEmpty ? "未設定" : song.inst)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(Int(song.compdeg * 100))%")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)

                Button("編集", action: onEdit)
                    .buttonStyle(.bordered)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
