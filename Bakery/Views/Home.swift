////
////  Home.swift
////  Bakery
////
////  Created by Maryam Bahwal on 17/07/1446 AH.
////
////
//
import SwiftUI
struct Home: View {
    @StateObject private var bookingViewModel = BookingViewModel(reachability: Reachability.init())
    @StateObject private var courseViewModel = CourseViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var reachability: Reachability // Access Reachability
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var searchText = ""
    
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView
            VStack(alignment: .leading, spacing: 0) {
                // Offline Banner
                if !reachability.isConnected {
                    HStack {
                        Image(systemName: "wifi.slash")
                        Text("You are offline")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                }
                
                // Title
                Text("Home Bakery")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Divider
                Divider()
                    .padding(.vertical, 20)
                
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                
                // Upcoming Section
                UpcomingSection(bookingViewModel: bookingViewModel, courseViewModel: courseViewModel)
                    .environmentObject(authViewModel)
                //                UpcomingSection()
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                // Popular Courses Section
                Text("Popular Courses")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                CoursesSection(viewModel: courseViewModel, searchText: $searchText)
                    .padding(.horizontal)
                
                Spacer()
            }
            .onChange(of: reachability.isConnected) { isConnected in
                            toastMessage = isConnected ? "You are back online" : "You are offline"
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                        .overlay(
                            Group {
                                if showToast {
                                    Toast(message: toastMessage)
                                        .padding()
                                }
                            },
                            alignment: .bottom
                        )
            .background(Color(UIColor.systemGray6))
            .onAppear {
                courseViewModel.fetchCourses()
                if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                    bookingViewModel.fetchBookings(for: userID)
                    courseViewModel.fetchCourses()
                }
            }
            .onChange(of: searchText) { newValue in
                courseViewModel.filterCourses(by: newValue)
            }
        }
    }
}

struct UpcomingSection: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var bookingViewModel: BookingViewModel
    @ObservedObject var courseViewModel: CourseViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upcoming")
                .font(.title2)
                .fontWeight(.medium)
            
            if authViewModel.isAuthenticated {
                if let upcomingBooking = bookingViewModel.bookings.first(where: { $0.fields.status == "Pending" }),
                   let course = courseViewModel.courses.first(where: { $0.id == upcomingBooking.fields.courseID }) {
                    // Display the upcoming course
                    HStack(spacing: 12) {
                        // Date section
                        VStack {
                            Text(courseViewModel.formattedMonth(from: TimeInterval(course.startDate)))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(UIColor.brown))
                            Text(courseViewModel.formattedDay(from: TimeInterval(course.startDate)))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(UIColor.brown))
                        }
                        .frame(width: 56, height: 56)
                        .cornerRadius(8)
                        
                        // Divider
                        Rectangle()
                            .fill(Color(UIColor.brown))
                            .frame(width: 2)
                        
                        // Content section
                        VStack(alignment: .leading, spacing: 4) {
                            Text(course.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 8) {
                                Label(course.locationName, systemImage: "mappin.and.ellipse")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            HStack(spacing: 8) {
                                Label(courseViewModel.formattedTime(from: TimeInterval(course.startDate)), systemImage: "hourglass")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onAppear {
                                    courseViewModel.fetchCourses()
                                    if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                                        bookingViewModel.fetchBookings(for: userID)
                                    }
                                }
                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 2)
                } else {
                    // No upcoming courses
                    VStack{
                        Image("unSignIn")
                            .resizable()
                            .frame(width: 171.63, height: 43 , alignment: .center)
                        Text("You don't have any booked courses")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(20)
                }
            } else {
                // User is not signed in
                VStack{
                    Image("unSignIn")
                        .resizable()
                        .frame(width: 171.63, height: 43 , alignment: .center)
                    Text("Sign in to view your upcoming courses")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    //                    .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(20)
            }
        }
        .onAppear {
                        courseViewModel.fetchCourses()
                        if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                            bookingViewModel.fetchBookings(for: userID)
                        }
                    }
    }
}
// Popular Courses Section
struct CoursesSection: View {
    @ObservedObject var viewModel: CourseViewModel
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.filteredCourses, id: \.id) { course in
                        // Add NavigationLink here
                        NavigationLink(destination: Details(course: course)) {
                            CourseRow(course: course)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove the default button styling
                    }
                }
            }
        }
    }
}

// Custom SearchBar view
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .padding(.horizontal, 30)
                .background(Color(.systemGray5))
                .cornerRadius(15) // Rounded corners
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                )
        }
    }
}

// Course Row
struct CourseRow: View {
    let course: Course
    @StateObject private var viewModel = CourseViewModel()
    @State private var imageData: Data? = nil // Store image data
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 84, height: 75)
                        .cornerRadius(2)
                        .padding(7)
                } else {
                    ProgressView()
                        .frame(width: 94, height: 85)
                        .onAppear {
                            loadImage(from: course.imageURL)
                        }
                }
                //                AsyncImage(url: URL(string: course.imageURL)) { phase in
                //                    switch phase {
                //                    case .empty:
                //                        ProgressView()
                //                            .frame(width: 94, height: 85)
                //                    case .success(let image):
                //                        image
                //                            .resizable()
                //                            .frame(width: 84, height: 75)
                //                            .cornerRadius(2)
                //                            .padding(7)
                //                    case .failure:
                //                        Image(systemName: "photo")
                //                            .resizable()
                //                            .frame(width: 80, height: 80)
                //                            .foregroundColor(.gray)
                //                    @unknown default:
                //                        Image(systemName: "exclamationmark.triangle")
                //                            .resizable()
                //                            .frame(width: 80, height: 80)
                //                            .foregroundColor(.red)
                //                    }
                //                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(course.title)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text(course.level.rawValue.capitalized)
                        .font(.system(size: 10))
                        .padding(.horizontal , 5)
                        .background(Color.aPrimary.opacity(0.3))
                        .cornerRadius(20)
                    
                    HStack {
                        Image(systemName: "clock").resizable().frame(width: 10, height: 10)
                        Text(viewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
                            .font(.caption)
                    }
                    .padding(.top, 2)
                    
                    HStack {
                        Image(systemName: "calendar").resizable().frame(width: 10, height: 10)
                        Text(viewModel.formattedDateAndTime(from: TimeInterval(course.startDate)))
                            .font(.caption)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity , maxHeight: 60 , alignment: .leading)
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 2)
    }
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.imageData = data // Save image data
                }
            }
        }.resume()
    }
}

