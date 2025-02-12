//
//  Booking.swift
//  Bakery
//
//  Created by Maryam Bahwal on 17/07/1446 AH.
//

import Foundation

struct AllBookingRecord: Codable {
    let records: [BookingRecord]
}

struct BookingRecord: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: BookingFields
}

struct BookingFields: Codable {
    let courseID: String
    let userID: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case userID = "user_id"
        case status
    }
}
