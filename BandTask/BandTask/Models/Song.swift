import Foundation

struct Song: Identifiable, Codable {
    var id: UUID = UUID()
    var songname: String
    var artist: String
    var compdeg: Double
    var inst: String
    var link: String
    var memo: String
}
