import Foundation
import SwiftUI

// Custom AsyncImage with caching
struct CachedAsyncImage: View {
    let url: URL
    @State private var imageData: Data? = nil
    
//    @EnvironmentObject var reachability: Reachability // Access Reachability

    
    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear {
                        fetchImage()
                    }
            }
        }
    }
    
    private func fetchImage() {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response {
                // Cache the response
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
}
class APIService {
        func fetchData(completion: @escaping (Result<AllCourseRecord, Error>) -> Void) {
            guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course") else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
            
            // Set cache policy to use cached data if available
            request.cachePolicy = .returnCacheDataElseLoad
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let allCourseRecord = try decoder.decode(AllCourseRecord.self, from: data)
                    completion(.success(allCourseRecord))
                } catch {
                    print("Decoding Error:", error.localizedDescription)
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
//    func fetchData(completion: @escaping (Result<AllCourseRecord, Error>) -> Void) {
//        guard let url = URL(string: "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course") else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error:", error.localizedDescription)
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            
//            do {
//                let decoder = JSONDecoder()
//                let allCourseRecord = try decoder.decode(AllCourseRecord.self, from: data)
//                completion(.success(allCourseRecord))
//            } catch {
//                print("Decoding Error:", error.localizedDescription)
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }
}

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var filteredCourses: [Course] = []
    
    private let apiService = APIService()
    //New
//    private let userDefaultsKey = "cachedCourses" // Key for UserDefaults
    
    //New
//    init() {
//        loadCachedCourses() // Load cached courses when the ViewModel is initialized
//    }
    
    func fetchCourses() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchData { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let allCourseRecord):
                    self.courses = allCourseRecord.records.map { $0.fields }
                    self.filteredCourses = self.courses // Show all courses initially
                    //New
//                    self.saveCoursesToCache() // Save fetched courses to cache
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Fetch Error:", error.localizedDescription)
                }
            }
        }
    }
    //New
    // Save courses to UserDefaults
//    private func saveCoursesToCache() {
//        let encoder = JSONEncoder()
//        if let encodedData = try? encoder.encode(courses) {
//            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
//            print("Courses saved to cache.")
//        }
//    }
//    //New
//    // Load courses from UserDefaults
//    private func loadCachedCourses() {
//        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
//            let decoder = JSONDecoder()
//            if let cachedCourses = try? decoder.decode([Course].self, from: savedData) {
//                self.courses = cachedCourses
//                self.filteredCourses = cachedCourses
//                print("Courses loaded from cache.")
//            }
//        }
//    }
    
    // Helper function to format date and time
    func formattedDateAndTime(from startDate: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: startDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM - h:mm a" // Custom format: "15 Dec - 4:00 pm"
        return dateFormatter.string(from: date)
    }
    func calculateDurationInHours(startTime: TimeInterval, endTime: TimeInterval) -> String {
        let duration = endTime - startTime
        let hours = duration / 3600  // Convert the duration from seconds to hours
        return String(format: "%.0fh", hours)
    }
    
    
    
    func filterCourses(by searchText: String) {
        if searchText.isEmpty {
            filteredCourses = courses
        } else {
            filteredCourses = courses.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    func formattedMonth(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM" // Example: "Dec"
        return dateFormatter.string(from: date)
    }
    
    func formattedDay(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // Example: "15"
        return dateFormatter.string(from: date)
    }
    
    func formattedTime(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Example: "4:00 PM"
        return dateFormatter.string(from: date)
    }
}


