import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case title = "曲名順"
    case completion = "完成度順"

    var id: String { self.rawValue }
}

struct Home: View {
    @EnvironmentObject var manager: SongMane
    @State private var showingReg = false
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .title
    @State private var songToEdit: Song? = nil

    var sortedSongs: [Song] {
        switch sortOption {
        case .title:
            return manager.songs.sorted {
                $0.songname.localizedCompare($1.songname) == .orderedAscending
            }
        case .completion:
            return manager.songs.sorted {
                $0.compdeg > $1.compdeg
            }
        }
    }

    var filteredSongs: [Song] {
        if searchText.isEmpty {
            return sortedSongs
        } else {
            return sortedSongs.filter {
                $0.songname.localizedCaseInsensitiveContains(searchText) ||
                $0.artist.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("並び替え", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filteredSongs) { song in
                        NavigationLink(destination: SongDetailView(song: song)) {
                            SongRowView(song: song) {
                                songToEdit = song
                                showingReg = true
                            }
                        }
                    }
                    .onDelete(perform: rowRemove)
                }
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "曲名またはアーティストで検索"
                )
            }
            .navigationTitle("曲")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        songToEdit = nil
                        showingReg = true
                    }) {
                        Image(systemName: "plus")
                        Text("新規")
                    }
                }
            }
            .sheet(isPresented: $showingReg) {
                SongReg(editingSong: songToEdit).environmentObject(manager)
            }
        }
    }

    func rowRemove(at offsets: IndexSet) {
        manager.songs.remove(atOffsets: offsets)
    }
}
