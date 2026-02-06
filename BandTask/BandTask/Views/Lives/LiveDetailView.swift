import SwiftUI

struct LiveDetailView: View {
    var live: Live
    var onEdit: () -> Void

    var body: some View {
        let formattedDate = live.date.formatted(date: .long, time: .omitted)

        return ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Divider()
                Text("バンド名")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(live.bandName)
                    .font(.largeTitle)
                    .fontWeight(.heavy)

                Divider()
                Text("日程")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(formattedDate)
                    .font(.title)
                    .fontWeight(.bold)

                Divider()
                Text("セットリスト")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if live.setlist.isEmpty {
                    Text("セットリストは未設定です")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(live.setlist.indices, id: \.self) { index in
                        Text("\(index + 1). \(live.setlist[index])")
                            .font(.headline)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("ライブ詳細")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("編集", action: onEdit)
            }
        }
    }
}
