//
//  AuthViewModel.swift
//  Bakery
//
//  Created by Maryam Bahwal on 26/07/1446 AH.
//
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var currentUserID: String?
    @Published var currentUser: User? = nil
    
    //New
    private let userDefaults = UserDefaults.standard
    private let authKey = "isAuthenticated"
    private let userKey = "currentUser"
    
    
    //
//    @EnvironmentObject var reachability: Reachability // Access Reachability
    private var reachability: Reachability

        init(reachability: Reachability) {
            self.reachability = reachability
//        }
//    init() {
            // Restore authentication state and user data from UserDefaults
            self.isAuthenticated = userDefaults.bool(forKey: authKey)
            if let userData = userDefaults.data(forKey: userKey),
               let user = try? JSONDecoder().decode(User.self, from: userData) {
                self.currentUser = user
                self.currentUserID = user.id
            }
        }
    
    func signIn(username: String, password: String) {
        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        // Check if the device is online
        if reachability.isConnected {
            request.cachePolicy = .reloadRevalidatingCacheData  // Get fresh data and update cache
        } else {
            request.cachePolicy = .returnCacheDataElseLoad  // Use cached data if available
        }
//        // Enable caching
//        request.cachePolicy = .returnCacheDataElseLoad // Use cached data if available
//        request.cachePolicy = .reloadRevalidatingCacheData
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from the server."
                }
                return
            }
            
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 dates
                let decodedResponse = try decoder.decode(AllUserRecord.self, from: data)
                
                // Print the decoded response for debugging
                print("Decoded Response: \(decodedResponse)")
                
                // Check if any user matches the provided credentials
                if let user = decodedResponse.records.first(where: { $0.fields.email == username && $0.fields.password == password }) {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.currentUserID = user.fields.id
                        self.currentUser = user.fields // Save user information
                        self.errorMessage = nil
                        
                        //New
                        // Save authentication state and user data to UserDefaults
                                                self.userDefaults.set(true, forKey: self.authKey)
                                                if let userData = try? JSONEncoder().encode(user.fields) {
                                                    self.userDefaults.set(userData, forKey: self.userKey)
                                                }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid credentials."
                    }
                }
            } catch let decodingError as DecodingError {
                DispatchQueue.main.async {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        self.errorMessage = "Type mismatch for \(type): \(context.debugDescription)"
                    case .valueNotFound(let type, let context):
                        self.errorMessage = "Value not found for \(type): \(context.debugDescription)"
                    case .keyNotFound(let key, let context):
                        self.errorMessage = "Key not found: \(key.stringValue), \(context.debugDescription)"
                    case .dataCorrupted(let context):
                        self.errorMessage = "Data corrupted: \(context.debugDescription)"
                    @unknown default:
                        self.errorMessage = "Unknown decoding error."
                    }
                }
                print("Decoding Error: \(decodingError)")
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
                print("Error: \(error)")
            }
        }.resume()
    }
}
