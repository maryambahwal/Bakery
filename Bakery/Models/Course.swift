import Foundation

// MARK: - Welcome
struct AllCourseRecord: Codable {
    let records: [CourseRecord]
}

// MARK: - Record
struct CourseRecord: Codable {
    let id: String
    let createdTime: CustomCreatedTime // Renamed to avoid ambiguity
    let fields: Course
}

// Custom CreatedTime enum for handling date formatting
enum CustomCreatedTime: Codable {
    case iso8601(String) // For the case where the date is in ISO8601 string format
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = .iso8601(string) // Assuming all dates are in ISO8601 format
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .iso8601(let dateString):
            try container.encode(dateString)
        }
    }
}

// MARK: - Fields
struct Course: Codable {
    let locationLongitude: Double
    let locationName: String
    let locationLatitude: Double
    let title: String
    let imageURL: String
    let level: Level
    let endDate: Int
    let id, chefID, description: String
    let startDate: Int

    enum CodingKeys: String, CodingKey {
        case locationLongitude = "location_longitude"
        case locationName = "location_name"
        case locationLatitude = "location_latitude"
        case title
        case imageURL = "image_url"
        case level
        case endDate = "end_date"
        case id
        case chefID = "chef_id"
        case description
        case startDate = "start_date"
    }
    // Add a computed property for a unique identifier
        var uniqueID: String {
            return "\(id)-\(startDate)"
        }
}

enum Level: String, Codable {
    case advance = "advance"
    case beginner = "beginner"
    case intermediate = "intermediate"
}
