import SwiftUI

struct LiveReg: View {
    @EnvironmentObject var liveManager: LiveMane
    @EnvironmentObject var songManager: SongMane
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme // 追加: ダークモード判定用
    var editingLive: Live?

    @State private var date = Date()
    @State private var bandName = ""
    @State private var setlist: [String] = []
    @State private var selectedSong = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ライブ情報の登録")) {
                    DatePicker("日付", selection: $date, displayedComponents: .date)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                        .cornerRadius(5) // 角丸を追加して境界を明確に
                    
                    TextField("バンド名", text: $bandName)
                        .textFieldStyle(.roundedBorder) // RoundedBorderTextFieldStyle()は非推奨
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                        .cornerRadius(5) // 角丸を追加して境界を明確に
                }
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white) // 各行の背景色を設定


                Section(header: Text("セットリスト")) {
                    List {
                        ForEach(setlist.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1). \(setlist[index])")
                                Spacer()
                                Button(action: {
                                    setlist.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }

                    Picker("曲を追加", selection: $selectedSong) {
                        Text("選択").tag("")
                        ForEach(songManager.songs.map { $0.songname }.sorted(), id: \.self) { song in
                            Text(song).tag(song)
                        }
                    }
                    .onChange(of: selectedSong) { newValue in
                        if !newValue.isEmpty {
                            setlist.append(newValue)
                            selectedSong = ""
                        }
                    }
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white) // ダークモード対応
                    .cornerRadius(5) // 角丸を追加して境界を明確に
                }
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white) // 各行の背景色を設定

                Button(action: registerLive) {
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
            .navigationTitle(editingLive == nil ? "ライブの登録" : "ライブの編集")
            .onAppear {
                if let live = editingLive {
                    date = live.date
                    bandName = live.bandName
                    setlist = live.setlist
                }
            }
        }
    }

    private func registerLive() {
        let updatedLive = Live(
            id: editingLive?.id ?? UUID(),
            date: date,
            bandName: bandName,
            setlist: setlist
        )

        if let existing = editingLive {
            liveManager.updateLive(updatedLive)
        } else {
            liveManager.addLive(updatedLive)
        }
        dismiss()
    }
}
