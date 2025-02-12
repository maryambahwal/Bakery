//
//  ChefViewModel.swift
//  Bakery
//
//  Created by Maryam Bahwal on 21/07/1446 AH.
//

import Foundation
import Combine
import SwiftUICore

class ChefViewModel: ObservableObject {
    @Published var chefName: String = "Loading..."
    private var cancellables = Set<AnyCancellable>()
    
    @Published var chef: Chef? = nil
        @Published var isLoading = false
        @Published var errorMessage: String? = nil

//    @EnvironmentObject var reachability: Reachability // Access Reachability
    

    func fetchChef(chefID: String) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/chef?filterByFormula=id=\"\(chefID)\"") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        // Use caching
        request.cachePolicy = .returnCacheDataElseLoad
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: AllChefRecord.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching chef: \(error.localizedDescription)")
                    self.chefName = "Error loading chef"
                }
            } receiveValue: { [weak self] welcome in
                if let chef = welcome.records.first {
                    self?.chefName = chef.fields.name
                } else {
                    self?.chefName = "Chef not found"
                }
            }
            .store(in: &cancellables)
    }
}
