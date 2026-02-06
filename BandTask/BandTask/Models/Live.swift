import Foundation

struct Live: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var bandName: String
    var setlist: [String]
}
