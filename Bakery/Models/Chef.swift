// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct AllChefRecord: Codable {
    let records: [ChefRecord]
}

// MARK: - Record
struct ChefRecord: Codable {
    let id, createdTime: String
    let fields: Chef
}

// MARK: - Fields
struct Chef: Codable {
    let id, name, email, password: String
}
