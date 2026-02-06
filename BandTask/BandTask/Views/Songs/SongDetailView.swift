import SwiftUI

struct SongDetailView: View {
    let song: Song

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Divider()
                Text("曲名")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(song.songname)
                    .font(.largeTitle)
                    .fontWeight(.heavy)

                Divider()
                Text("アーティスト名")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(song.artist)
                    .font(.title)
                    .fontWeight(.bold)

                Divider()
                Text("パート")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(song.inst.isEmpty ? "未設定" : song.inst)
                    .font(.title)
                    .fontWeight(.semibold)

                Divider()
                Text("完成度")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(Int(song.compdeg * 100))%")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Divider()
                if let url = URL(string: song.link), !song.link.isEmpty {
                    Link("YouTubeで聞く", destination: url)
                        .foregroundColor(.blue)
                        .underline()
                }

                Divider()
                Text("メモ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(song.memo)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("詳細")
    }
}
