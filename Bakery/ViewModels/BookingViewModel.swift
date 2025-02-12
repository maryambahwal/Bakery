//
//  BookingViewModel.swift
//  Bakery
//
//  Created by Maryam Bahwal on 25/07/1446 AH.
//
import Foundation
import SwiftUICore

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isBookingSuccessful = false // To track successful booking creation

//    @EnvironmentObject var reachability: Reachability // Access Reachability
    private var reachability: Reachability

        init(reachability: Reachability) {
            self.reachability = reachability
        }

    // Fetch bookings for a specific user
    func fetchBookings(for userID: String) {
            isLoading = true
            errorMessage = nil
            
            let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking?filterByFormula=user_id=\"\(userID)\"")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        if reachability.isConnected {
            request.cachePolicy = .reloadRevalidatingCacheData  // Get fresh data and update cache
        } else {
            request.cachePolicy = .returnCacheDataElseLoad  // Use cached data if available
        }
            // Set cache policy to use cached data if available
//            request.cachePolicy = .returnCacheDataElseLoad
//        request.cachePolicy = .reloadRevalidatingCacheData

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let data = data else {
                        self.errorMessage = "No data received."
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let bookingResponse = try decoder.decode(AllBookingRecord.self, from: data)
                        self.bookings = bookingResponse.records
                    } catch {
                        self.errorMessage = "Failed to decode bookings: \(error.localizedDescription)"
                    }
                }
            }.resume()
        }
    
//    func fetchBookings(for userID: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking?filterByFormula=user_id=\"\(userID)\"")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                
//                guard let data = data else {
//                    self.errorMessage = "No data received."
//                    return
//                }
//                
//                do {
//                    let decoder = JSONDecoder()
//                    let bookingResponse = try decoder.decode(AllBookingRecord.self, from: data)
//                    self.bookings = bookingResponse.records
//                } catch {
//                    self.errorMessage = "Failed to decode bookings: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//    }

    // Cancel a booking by its ID
    func cancelBooking(bookingID: String) {
        isLoading = true
        errorMessage = nil
        
        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking/\(bookingID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        // Set cache policy to use cached data if available
//        request.cachePolicy = .returnCacheDataElseLoad
//        request.cachePolicy = .reloadRevalidatingCacheData
        if reachability.isConnected {
            request.cachePolicy = .reloadRevalidatingCacheData  // Get fresh data and update cache
        } else {
            request.cachePolicy = .returnCacheDataElseLoad  // Use cached data if available
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response from server."
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    // Invalidate cache and refetch bookings
                                    if let userID = self.bookings.first(where: { $0.id == bookingID })?.fields.userID {
                                        self.fetchBookings(for: userID)
                                    }
                    // Remove the canceled booking from the list
//                    self.bookings.removeAll { $0.id == bookingID }
                    self.objectWillChange.send() // Force view update
                } else {
                    self.errorMessage = "Failed to cancel booking. Status code: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }

    // Create a new booking
    func createBooking(courseID: String, userID: String) {
        isLoading = true
        errorMessage = nil
        
        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "course_id": courseID,
                "user_id": userID,
                "status": "Pending"
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        if reachability.isConnected {
            request.cachePolicy = .reloadRevalidatingCacheData  // Get fresh data and update cache
        } else {
            request.cachePolicy = .returnCacheDataElseLoad  // Use cached data if available
        }
        // Use caching
//        request.cachePolicy = .returnCacheDataElseLoad
//        request.cachePolicy = .reloadRevalidatingCacheData

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response from server."
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    self.isBookingSuccessful = true
                    // Optionally, fetch updated bookings after creating a new one
                    self.fetchBookings(for: userID)
                    self.objectWillChange.send() // Force view update
                } else {
                    self.errorMessage = "Failed to create booking. Status code: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
