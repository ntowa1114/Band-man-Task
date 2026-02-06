import SwiftUI
import UIKit

struct SongReg: View {
    @EnvironmentObject var manager: SongMane
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme // 追加: ダークモード判定用
    var editingSong: Song?
    @State private var songname = ""
    @State private var artist = ""
    @State private var compdeg: Double = 0.5
    @State private var inst = ""
    @State private var link = ""
    @State private var memo = ""
    @State private var selectionValue = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("曲情報の登録")) {
                    TextField("曲名", text: $songname)
                        .textFieldStyle(.roundedBorder) // RoundedBorderTextFieldStyle()は非推奨
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                        .cornerRadius(5) // 角丸を追加して境界を明確に
                    
                    TextField("アーティスト名", text: $artist)
                        .textFieldStyle(.roundedBorder) // RoundedBorderTextFieldStyle()は非推奨
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                        .cornerRadius(5) // 角丸を追加して境界を明確に
                    
                    Picker("パートを選択", selection: $selectionValue) {
                        Text("未設定").tag(0)
                        Text("ギター").tag(1)
                        Text("ベース").tag(2)
                        Text("ドラム").tag(3)
                        Text("ボーカル").tag(4)
                        Text("リードギター").tag(5)
                        Text("バッキングギター").tag(6)
                        Text("ギターボーカル").tag(7)
                        Text("ベースボーカル").tag(8)
                    }
                    .pickerStyle(.menu)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                    .cornerRadius(5) // 角丸を追加して境界を明確に


                    HStack {
                        Text("完成度")
                        Slider(value: $compdeg, in: 0...1, step: 0.01)
                        Text(String(format: "%.0f%%", compdeg * 100))
                            .frame(width: 50, alignment: .trailing)
                    }
                    .padding(.vertical, 5) // パディングを追加して区切りを明確に

                    HStack {
                        TextField("YouTube等のリンク", text: $link)
                            .textFieldStyle(.roundedBorder) // RoundedBorderTextFieldStyle()は非推奨
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                            .cornerRadius(5) // 角丸を追加して境界を明確に

                        Button("Paste") {
                            if let clipboard = UIPasteboard.general.string {
                                link = clipboard
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    TextField("メモ", text: $memo, axis: .vertical) // axis: .vertical で複数行に対応
                        .frame(minHeight: 100, alignment: .topLeading) // 最小の高さを設定
                        .textFieldStyle(.roundedBorder) // RoundedBorderTextFieldStyle()は非推奨
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                        .cornerRadius(5) // 角丸を追加して境界を明確に
                }
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white) // 各行の背景色を設定

                Button(action: registerSong) {
                    Text("登録")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .listRowBackground(Color.clear) // ボタンの行の背景は透明に
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear) // Form全体の背景は自動調整に任せるか、clearに

            .navigationTitle("曲の登録")
            .onAppear {
                if let song = editingSong {
                    songname = song.songname
                    artist = song.artist
                    compdeg = song.compdeg
                    inst = song.inst
                    link = song.link
                    memo = song.memo
                    selectionValue = instTag(inst)
                }
            }
        }
    }

    private func registerSong() {
        inst = instName(for: selectionValue)
        let updatedSong = Song(
            id: editingSong?.id ?? UUID(),
            songname: songname,
            artist: artist,
            compdeg: compdeg,
            inst: inst,
            link: link,
            memo: memo
        )

        if let existing = editingSong {
            manager.updateSong(updatedSong)
        } else {
            manager.addSong(updatedSong)
        }

        dismiss()
    }

    private func instName(for value: Int) -> String {
        switch value {
        case 1: return "ギター"
        case 2: return "ベース"
        case 3: return "ドラム"
        case 4: return "ボーカル"
        case 5: return "リードギター"
        case 6: return "バッキングギター"
        case 7: return "ギターボーカル"
        case 8: return "ベースボーカル"
        default: return "未設定"
        }
    }
    private func instTag(_ inst: String) -> Int {
        switch inst {
        case "ギター": return 1
        case "ベース": return 2
        case "ドラム": return 3
        case "ボーカル": return 4
        case "リードギター": return 5
        case "バッキングギター": return 6
        case "ギターボーカル": return 7
        case "ベースボーカル": return 8
        default: return 0
        }
    }
}

#Preview {
    SongReg().environmentObject(SongMane())
}
