import Foundation

struct Petition: Codable {
    let title: String
    let body: String
    let signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
