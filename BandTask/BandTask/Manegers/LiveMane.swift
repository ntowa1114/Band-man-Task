import Foundation
import Combine

class LiveMane: ObservableObject {
    @Published var lives: [Live] = []

    func addLive(_ live: Live) {
        lives.append(live)
    }

    func updateLive(_ updatedLive: Live) {
        if let index = lives.firstIndex(where: { $0.id == updatedLive.id }) {
            lives[index] = updatedLive
        }
    }

    func deleteLive(at index: Int) {
        guard lives.indices.contains(index) else { return }
        lives.remove(at: index)
    }
}
