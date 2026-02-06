import SwiftUI

enum LiveSortOption: String, CaseIterable, Identifiable {
    case date = "日付順"
    case bandName = "バンド名順"

    var id: String { self.rawValue }
}

struct LiveView: View {
    @EnvironmentObject var liveManager: LiveMane
    @EnvironmentObject var songManager: SongMane // LiveRegでSongManeが必要なため追加
    @State private var showingReg = false
    @State private var liveToEdit: Live? = nil
    @State private var searchText: String = ""
    @State private var sortOption: LiveSortOption = .date

    var sortedLives: [Live] {
        switch sortOption {
        case .date:
            return liveManager.lives.sorted { $0.date < $1.date }
        case .bandName:
            return liveManager.lives.sorted { $0.bandName.localizedCompare($1.bandName) == .orderedAscending }
        }
    }

    var filteredLives: [Live] {
        if searchText.isEmpty {
            return sortedLives
        } else {
            return sortedLives.filter {
                $0.bandName.localizedCaseInsensitiveContains(searchText) ||
                $0.setlist.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("並び替え", selection: $sortOption) {
                    ForEach(LiveSortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    ForEach(filteredLives) { live in
                        NavigationLink(destination: LiveDetailView(live: live) {
                            liveToEdit = live
                            showingReg = true
                        }) {
                            LiveRowView(live: live) {
                                liveToEdit = live
                                showingReg = true
                            }
                        }
                    }
                    .onDelete(perform: rowRemove)
                }
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic),
                    prompt: "バンド名またはセットリストで検索"
                )
            }
            .navigationTitle("ライブ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        liveToEdit = nil
                        showingReg = true
                    }) {
                        Image(systemName: "plus")
                        Text("新規")
                    }
                }
            }
            .sheet(isPresented: $showingReg) {
                LiveReg(editingLive: liveToEdit)
                    .environmentObject(liveManager)
                    .environmentObject(songManager)
            }
        }
    }

    func rowRemove(at offsets: IndexSet) {
        liveManager.lives.remove(atOffsets: offsets)
    }
}
