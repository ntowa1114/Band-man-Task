import Foundation
import Combine

class SongMane: ObservableObject {
    @Published var songs: [Song] = []

    func addSong(_ song: Song) {
        songs.append(song)
    }

    func deleteSong(at index: Int) {
        guard songs.indices.contains(index) else { return }
        songs.remove(at: index)
    }

    func updateSong(_ updatedSong: Song) {
        if let index = songs.firstIndex(where: { $0.id == updatedSong.id }) {
            songs[index] = updatedSong
        }
    }

    func clearAll() {
        songs.removeAll()
    }
}
