////
////  UserViewModel.swift
////  Bakery
////
////  Created by Maryam Bahwal on 25/07/1446 AH.
////
//
//import Foundation
//
//class UserViewModel: ObservableObject {
//    @Published var isSignedIn = false
//    @Published var userID: String?
//    @Published var userName: String?
//    
//    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            do {
//                // Decode directly into an array of `UserRecord` from the "records" key
//                let decodedResponse = try JSONDecoder().decode([String: [UserRecord]].self, from: data)
//                if let users = decodedResponse["records"] {
//                    if let user = users.first(where: { $0.fields.email == email && $0.fields.password == password }) {
//                        DispatchQueue.main.async {
//                            self.isSignedIn = true
//                            self.userID = user.fields.id
//                            self.userName = user.fields.name
//                            completion(.success(()))
//                        }
//                    } else {
//                        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
//                    }
//                } else {
//                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No users found"])))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}




//
//import Foundation
//import Combine
//
//class UserViewModel: ObservableObject {
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    // Fetch user data by user ID
//    func fetchUser(userID: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user?filterByFormula=id=\"\(userID)\"")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: AllUserRecord.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] userRecord in
//                self?.user = userRecord.records.first?.fields
//            }
//            .store(in: &cancellables)
//    }
//    
//    // Update user's name
//    func updateUser(userID: String, name: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user/\(userID)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "fields": [
//                "name": name
//            ]
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: UserRecord.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] updatedUser in
//                self?.user = updatedUser.fields
//            }
//            .store(in: &cancellables)
//    }
//}




//
//import Foundation
//import Combine
//
//class UserViewModel: ObservableObject {
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    func fetchUser(userID: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user?filterByFormula=id=\"\(userID)\"")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: AllUserRecord.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] userRecord in
//                self?.user = userRecord.records.first?.fields
//            }
//            .store(in: &cancellables)
//    }
//    
//    func updateUser(userID: String, name: String) {
//        isLoading = true
//        errorMessage = nil
//        
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user/\(userID)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let body: [String: Any] = [
//            "fields": [
//                "name": name
//            ]
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = "Failed to update user: \(error.localizedDescription)"
//                    print("Update Error: \(error)")
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] data in
//                // Print the raw JSON response
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Raw JSON Response: \(jsonString)")
//                }
//                
//                // Decode the response
//                do {
//                    let updatedUser = try JSONDecoder().decode(UserRecord.self, from: data)
//                    self?.user = updatedUser.fields
//                    self?.objectWillChange.send() // Force UI refresh
//                    print("User updated successfully: \(updatedUser.fields.name ?? "No name")")
//                } catch {
//                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
//                    print("Decoding Error: \(error)")
//                }
//            })
//            .store(in: &cancellables)
//    }
//}
import Foundation
import Combine
import SwiftUICore

class UserViewModel: ObservableObject {
//    @EnvironmentObject var reachability: Reachability // Access Reachability

    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var reachability: Reachability

        init(reachability: Reachability) {
            self.reachability = reachability
        }
    func fetchUser(userID: String) {
        isLoading = true
        errorMessage = nil

        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user?filterByFormula=id=\"\(userID)\"")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        if reachability.isConnected {
            request.cachePolicy = .reloadRevalidatingCacheData  // Get fresh data and update cache
        } else {
            request.cachePolicy = .returnCacheDataElseLoad  // Use cached data if available
        }
        // Set cache policy to use cached data if available
//        request.cachePolicy = .returnCacheDataElseLoad
//        request.cachePolicy = .reloadRevalidatingCacheData

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AllUserRecord.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] userRecord in
                if let record = userRecord.records.first {
                    var user = record.fields
                    user.recordID = record.id // Store the Record ID
                    self?.user = user
                } else {
                    self?.errorMessage = "No user found with ID: \(userID)"
                }
            }
            .store(in: &cancellables)
    }
    func updateUser(name: String) {
            isLoading = true
            errorMessage = nil

            guard let recordID = user?.recordID else {
                errorMessage = "Record ID not found."
                isLoading = false
                return
            }

            let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user/\(recordID)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "fields": [
                    "name": name
                ]
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = "Failed to update user: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        self.errorMessage = "Invalid response from server."
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        // Update the user's name locally
                        self.user?.name = name // Update @Published property
                        
                                        self.objectWillChange.send() // Force view update
                    } else {
                        self.errorMessage = "Failed to update user. Status code: \(httpResponse.statusCode)"
                    }
                }
            }.resume()
        }
//    func updateUser(name: String) {
//        isLoading = true
//        errorMessage = nil
//
//        // Ensure the Record ID is available
//        guard let recordID = user?.recordID else {
//            errorMessage = "Record ID not found."
//            isLoading = false
//            return
//        }
//
//        let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/user/\(recordID)")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: Any] = [
//            "fields": [
//                "name": name
//            ]
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//        print("Sending update request for Record ID: \(recordID) with name: \(name)")
//        
//        // Set cache policy to use cached data if available
//        request.cachePolicy = .returnCacheDataElseLoad
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, response in
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    throw URLError(.badServerResponse)
//                }
//                print("Status Code: \(httpResponse.statusCode)")
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Raw JSON Response: \(jsonString)")
//                }
//                return data
//            }
//            .decode(type: UserRecord.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = "Failed to update user: \(error.localizedDescription)"
//                    print("Update Error: \(error)")
//                case .finished:
//                    print("Update request completed successfully.")
//                }
//            }, receiveValue: { [weak self] updatedUser in
//                print("Received updated user: \(updatedUser.fields.name ?? "No name")")
//                self?.user = updatedUser.fields
//                self?.objectWillChange.send() // Force UI refresh
//            })
//            .store(in: &cancellables)
//    }
}
