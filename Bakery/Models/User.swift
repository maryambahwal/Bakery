////
////  User.swift
////  Bakery
////
////  Created by Maryam Bahwal on 17/07/1446 AH.
////

struct AllUserRecord: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String? // Make id optional
    let createdTime: String? // Make createdTime optional
    let fields: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime = "createdTime"
        case fields
    }
}

struct User: Codable {
    let id: String? // Custom ID field
    var recordID: String? // Add this to store the Record ID
    var name: String?
    let email: String?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case id
        case recordID = "recordId" // Map to the correct key in the API response
        case name
        case email
        case password
    }
}
