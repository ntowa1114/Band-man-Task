import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var songManager: SongMane
    @EnvironmentObject var liveManager: LiveMane
    @Environment(\.colorScheme) var colorScheme // ダークモード判定用

    // 今から近いライブの予定 (最大3件)
    var upcomingLives: [Live] {
        liveManager.lives
            .filter { $0.date >= Date() } // 今日以降のライブ
            .sorted { $0.date < $1.date } // 日付順にソート
            .prefix(3) // 最大3件
            .map { $0 }
    }

    // 完成度の低い曲 (最大3件)
    var lowCompletionSongs: [Song] {
        songManager.songs
            .filter { $0.compdeg < 1.0 } // 完成度が100%未満の曲
            .sorted { $0.compdeg < $1.compdeg } // 完成度が低い順にソート
            .prefix(3) // 最大3件
            .map { $0 }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - LIVE SCHEDULE
                    VStack(alignment: .leading) {
                        HStack {
                            Text("LIVE SCHEDULE")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                            NavigationLink(destination: LiveView()) { // LiveViewへのリンク
                                Text("全て表示")
                                    .font(.callout)
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                            }
                        }

                        if upcomingLives.isEmpty {
                            Text("今後のライブ予定はありません。")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
                                .padding(.horizontal)
                        } else {
                            ForEach(upcomingLives) { live in
                                NavigationLink(destination: LiveDetailView(live: live, onEdit: { })) { // onEditはダミー
                                    LiveScheduleRowView(live: live)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
                                        .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle()) // NavigationLinkのデフォルトスタイルを解除
                            }
                        }
                    }

                    // MARK: - QUICKLY PRACTICE
                    VStack(alignment: .leading) {
                        HStack {
                            Text("QUICKLY PRACTICE")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.leading)
                            Spacer()
                            NavigationLink(destination: Home()) { // Home (曲リスト) へのリンク
                                Text("全て表示")
                                    .font(.callout)
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                            }
                        }

                        if lowCompletionSongs.isEmpty {
                            Text("完成度の低い曲はありません。")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
                                .padding(.horizontal)
                        } else {
                            ForEach(lowCompletionSongs) { song in
                                NavigationLink(destination: SongDetailView(song: song)) {
                                    QuickPracticeRowView(song: song)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)))
                                        .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle()) // NavigationLinkのデフォルトスタイルを解除
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("ホーム") // ナビゲーションタイトルを設定
        }
    }
}

// MARK: - Dashboard用の行ビュー (Live Schedule)
struct LiveScheduleRowView: View {
    let live: Live

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(live.bandName)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(live.date.formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// MARK: - Dashboard用の行ビュー (Quick Practice)
struct QuickPracticeRowView: View {
    let song: Song

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.songname)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(song.artist) - \(song.inst.isEmpty ? "未設定" : song.inst)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(Int(song.compdeg * 100))%")
                .font(.title3)
                .bold()
                .foregroundColor(.orange)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}


#Preview {
    DashboardView()
        .environmentObject(SongMane())
        .environmentObject(LiveMane())
}
