//
//  Details.swift
//  Bakery
//
//  Created by Maryam Bahwal on 20/07/1446 AH.
//
//import SwiftUI
//import MapKit
//
//struct Details: View {
//    let course: Course  // Pass the selected course
//    @StateObject private var chefViewModel = ChefViewModel()
//    @StateObject private var courseViewModel = CourseViewModel()
//    @State private var region: MKCoordinateRegion
//    
//    @State private var showSignInSheet = false
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    init(course: Course) {
//        self.course = course
//        // Initialize region using course properties
//        _region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Zoom level
//        ))
//    }
//
//    var body: some View {
//        VStack {
//            Text(course.title)
//                .font(.title2)
//                .bold()
//                .padding()
//            
////            Image("detailsImage")  // Replace with actual image
////                .resizable()
////                .frame(width: 430, height: 275)
//            AsyncImage(url: URL(string: course.imageURL)) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                        .frame(width: 80, height: 80)
//                case .success(let image):
//                    image
//                                    .resizable()
//                                    .frame(width: 430, height: 275)
//                case .failure:
//                    Image(systemName: "photo")
//                        .resizable()
//                        .frame(width: 80, height: 80)
//                        .foregroundColor(.gray)
//                @unknown default:
//                    Image(systemName: "exclamationmark.triangle")
//                        .resizable()
//                        .frame(width: 80, height: 80)
//                        .foregroundColor(.red)
//                }
//            }
//            
//            VStack(alignment: .leading) {
//                Text("About the course:")
//                    .bold()
//                    .padding(.vertical, 2)
//                Text(course.description) // Use course description
//                    .font(.system(size: 12.6))
//            }
//            .padding(1)
//            
//            Divider()
//                .padding()
//            
//            HStack {
//                Text("Chef:")
//                    .bold()
//                Text(chefViewModel.chefName) // Use course chef
//                    .font(.system(size: 14))
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.horizontal)
//            
//            HStack {
//                Text("Level:")
//                    .bold()
//                Text(course.level.rawValue.capitalized)
//                    .font(.system(size: 10))
//                    .padding(3)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                Spacer()
//                Text("Duration:")
//                    .bold()
//                Text(courseViewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
//
//                    .font(.system(size: 14))
//            }
//            .padding(.horizontal)
//            
//            HStack {
//                Text("Date & Time:")
//                    .bold()
//                Text(courseViewModel.formattedDateAndTime(from:  TimeInterval(course.startDate)))
//                    .font(.system(size: 14))
//                Spacer()
//                Text("Location:")
//                    .bold()
//                Text(course.locationName)
//                    .font(.system(size: 14))
//            }
//            .padding(.horizontal)
//            
//            Map(coordinateRegion: $region)
//                .frame(height: 106)
//                .cornerRadius(12)
//                .padding()
//            
////            Button(action: {
////                showSignInSheet.toggle() // Show the SignIn sheet
////            }) {
////                Text("Book a space")
////                    .font(.headline)
////                    .foregroundColor(.white)
////                    .padding()
////                    .frame(maxWidth: .infinity)
////                    .background(.aPrimary)
////                    .cornerRadius(10)
////            }
////            .padding(.horizontal)
////            
////        }
////        .sheet(isPresented: $showSignInSheet) {
////                    SignIn(onSignInSuccess: {
////                        print("Sign in successful!")
////                        showSignInSheet = false // Dismiss the sheet
////                    })
////                }
//            Button("Book this Course") {
//                            if authViewModel.isAuthenticated {
//                                // Proceed with booking logic
//                                print("Course booked!")
//                            } else {
//                                // Show the sign-in modal
//                                showSignInSheet = true
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                    .sheet(isPresented: $showSignInSheet) {
//                        SignIn()
//                            .environmentObject(authViewModel)
//                    }
//        .onAppear {
//            chefViewModel.fetchChef(chefID: course.chefID)
//                }
////        .navigationBarBackButtonHidden(true)
//    }
//}



//
//import SwiftUI
//import MapKit
//
//struct Details: View {
//    let course: Course  // Pass the selected course
//    @StateObject private var chefViewModel = ChefViewModel()
//    @StateObject private var courseViewModel = CourseViewModel()
//    @State private var region: MKCoordinateRegion
//    
//    @State private var showSignInSheet = false
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    init(course: Course) {
//        self.course = course
//        // Initialize region using course properties
//        _region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Zoom level
//        ))
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text(course.title)
//                    .font(.title2)
//                    .bold()
//                    .padding()
//                
//                // Image handling (remains unchanged)
//                AsyncImage(url: URL(string: course.imageURL)) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(width: 80, height: 80)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .frame(width: 430, height: 275)
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
//                
//                VStack(alignment: .leading) {
//                    Text("About the course:")
//                        .bold()
//                        .padding(.vertical, 2)
//                    Text(course.description) // Use course description
//                        .font(.system(size: 12.6))
//                }
//                .padding(1)
//                
//                Divider()
//                    .padding()
//                
//                HStack {
//                    Text("Chef:")
//                        .bold()
//                    Text(chefViewModel.chefName) // Use course chef
//                        .font(.system(size: 14))
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//                
//                HStack {
//                    Text("Level:")
//                        .bold()
//                    Text(course.level.rawValue.capitalized)
//                        .font(.system(size: 10))
//                        .padding(3)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(10)
//                    Spacer()
//                    Text("Duration:")
//                        .bold()
//                    Text(courseViewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
//                        .font(.system(size: 14))
//                }
//                .padding(.horizontal)
//                
//                HStack {
//                    Text("Date & Time:")
//                        .bold()
//                    Text(courseViewModel.formattedDateAndTime(from:  TimeInterval(course.startDate)))
//                        .font(.system(size: 14))
//                    Spacer()
//                    Text("Location:")
//                        .bold()
//                    Text(course.locationName)
//                        .font(.system(size: 14))
//                }
//                .padding(.horizontal)
//                
//                Map(coordinateRegion: $region)
//                    .frame(height: 106)
//                    .cornerRadius(12)
//                    .padding()
//                
//                // Button for booking course
//                Button("Book this Course") {
//                    if authViewModel.isAuthenticated {
//                        // Proceed with booking logic
//                        print("Course booked!")
//                    } else {
//                        // Show the sign-in navigation instead of the sheet
//                        showSignInSheet = true
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                
//                // Full-page NavigationLink instead of sheet
//                NavigationLink(
//                    destination: SignIn()
//                        .environmentObject(authViewModel),
//                    isActive: $showSignInSheet
//                ) {
//                    EmptyView() // Trigger navigation when showSignInSheet is true
//                }
//                .hidden() // Hide the navigation link itself
//            }
//            .onAppear {
//                chefViewModel.fetchChef(chefID: course.chefID)
//            }
//            .navigationTitle("Course Details") // Set a title if needed
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//}



//import SwiftUI
//import MapKit
//
//struct Details: View {
//    
//    let course: Course
//    @StateObject private var bookingViewModel = BookingViewModel()
//    @StateObject private var chefViewModel = ChefViewModel()
//    @StateObject private var courseViewModel = CourseViewModel()
//    @State private var region: MKCoordinateRegion
//    
//    @State private var showSignInSheet = false
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @Environment(\.presentationMode) var presentationMode // Add this line
//
//    init(course: Course) {
//        self.course = course
//        _region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        ))
//    }
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                   
//                    // Course Image
//                    AsyncImage(url: URL(string: course.imageURL)) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView()
//                                .frame(height: 200)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 240)
//                                .clipped()
//                        case .failure:
//                            Image(systemName: "photo")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 200)
//                                .clipped()
//                        @unknown default:
//                            Image(systemName: "exclamationmark.triangle")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 200)
//                                .clipped()
//                        }
//                    }
////                    .cornerRadius(12)
////                    .padding(.horizontal)
//                    
//                    // About the Course Section
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("About the course:")
//                            .font(.headline)
//                            .bold()
//                        
//                        Text(course.description)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal)
//                    
//                    Divider()
//                        .padding(.horizontal)
//                    
//                    // Course Details Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Text("Chef:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(chefViewModel.chefName)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack {
//                            Text("Level:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(course.level.rawValue.capitalized)
//                                .font(.caption)
//                                .padding(.horizontal , 5)
//                                .background(Color.aPrimary.opacity(0.3))
//                                .cornerRadius(20)
//
//                            Spacer()
//                            Text("Duration:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(courseViewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack {
//                            Text("Date & Time:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(courseViewModel.formattedDateAndTime(from: TimeInterval(course.startDate)))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Text("Location:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(course.locationName)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Map Section
//                    Map(coordinateRegion: $region)
//                        .frame(height: 130)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                    
//                    // Book a Space Button
//                    Button(action: {
//                        if authViewModel.isAuthenticated {
//                            // Safely unwrap the currentUserID
//                                    if let userID = authViewModel.currentUserID {
//                                        // Create a new booking
//                                        bookingViewModel.createBooking(courseID: course.id, userID: userID)
//                                    } else {
//                                        // Handle the case where currentUserID is nil
//                                        bookingViewModel.errorMessage = "User ID not found. Please sign in again."
//                                    }
//                        } else {
//                            showSignInSheet = true // Show the SignIn sheet
//                        }
//                    }) {
//                        Text("Book a space")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(.aPrimary)
//                            .cornerRadius(12)
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.vertical)
//            }
//            .navigationBarBackButtonHidden(true)
//            .sheet(isPresented: $showSignInSheet) {
//                    SignIn() // Present the SignIn view as a sheet
//                    .presentationDetents([.height(650)])
//                        .environmentObject(authViewModel)
//                }
//            .navigationTitle(course.title)
//                        .navigationBarTitleDisplayMode(.inline)
//                        .navigationBarBackButtonHidden(true) // Hide the default back button
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button(action: {
//                                    presentationMode.wrappedValue.dismiss() // Go back
//                                }) {
//                                    Image(systemName: "chevron.left") // Custom back arrow
//                                        .foregroundColor(.aPrimary)
//                                }
//                            }
//                        }
//                        .alert(isPresented: $bookingViewModel.isBookingSuccessful) {
//                                        Alert(
//                                            title: Text("Booking Successful"),
//                                            message: Text("Your booking has been confirmed."),
//                                            dismissButton: .default(Text("OK"))
//                                        )
//                                    }
//                                }
//        .navigationBarBackButtonHidden(true)
//            .onAppear {
//                chefViewModel.fetchChef(chefID: course.chefID)
//            }
//        
//        .accentColor(.aPrimary)
//    }
//}
//










//
//import SwiftUI
//import MapKit
//
//struct Details: View {
//    let course: Course
//    @StateObject private var bookingViewModel = BookingViewModel() // Use @StateObject correctly
//    @StateObject private var chefViewModel = ChefViewModel()
//    @StateObject private var courseViewModel = CourseViewModel()
//    @State private var region: MKCoordinateRegion
//    
//    @State private var showSignInSheet = false
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @Environment(\.presentationMode) var presentationMode
//
//    init(course: Course) {
//        self.course = course
//        _region = State(initialValue: MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        ))
//    }
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    // Course Image
//                    AsyncImage(url: URL(string: course.imageURL)) { phase in
//                        switch phase {
//                        case .empty:
//                            ProgressView()
//                                .frame(height: 200)
//                        case .success(let image):
//                            image
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 240)
//                                .clipped()
//                        case .failure:
//                            Image(systemName: "photo")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 200)
//                                .clipped()
//                        @unknown default:
//                            Image(systemName: "exclamationmark.triangle")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 200)
//                                .clipped()
//                        }
//                    }
//                    
//                    // About the Course Section
//                    VStack(alignment: .leading, spacing: 8) {
//                        Text("About the course:")
//                            .font(.headline)
//                            .bold()
//                        
//                        Text(course.description)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.horizontal)
//                    
//                    Divider()
//                        .padding(.horizontal)
//                    
//                    // Course Details Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        HStack {
//                            Text("Chef:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(chefViewModel.chefName)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack {
//                            Text("Level:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(course.level.rawValue.capitalized)
//                                .font(.caption)
//                                .padding(.horizontal , 5)
//                                .background(Color.aPrimary.opacity(0.3))
//                                .cornerRadius(20)
//
//                            Spacer()
//                            Text("Duration:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(courseViewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack {
//                            Text("Date & Time:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(courseViewModel.formattedDateAndTime(from: TimeInterval(course.startDate)))
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            Spacer()
//                            Text("Location:")
//                                .font(.subheadline)
//                                .bold()
//                            Text(course.locationName)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    // Map Section
//                    Map(coordinateRegion: $region)
//                        .frame(height: 130)
//                        .cornerRadius(12)
//                        .padding(.horizontal)
//                    
//                    // Book a Space Button
//                    Button(action: {
//                        if authViewModel.isAuthenticated {
//                            // Safely unwrap the currentUserID
//                            if let userID = authViewModel.currentUserID {
//                                // Call the createBooking method correctly
//                                bookingViewModel.createBooking(courseID: course.id, userID: userID)
//                            } else {
//                                // Handle the case where currentUserID is nil
//                                bookingViewModel.errorMessage = "User ID not found. Please sign in again."
//                            }
//                        } else {
//                            showSignInSheet = true // Show the SignIn sheet
//                        }
//                    }) {
//                        Text("Book a space")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(.aPrimary)
//                            .cornerRadius(12)
//                    }
//                    .padding(.horizontal)
//                    .overlay(
//                                    Group {
//                                        if bookingViewModel.isBookingSuccessful {
//                                            SuccessView()
//                                                .transition(.scale)
//                                                .onAppear {
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                                        bookingViewModel.isBookingSuccessful = false
//                                                        Profile()
//                                                    }
//                                                }
//                                        }
//                                    }
//                                )
//                }
//                .padding(.vertical)
//            }
//            .navigationBarBackButtonHidden(true)
//            .sheet(isPresented: $showSignInSheet) {
//                SignIn() // Present the SignIn view as a sheet
//                    .presentationDetents([.height(650)])
//                    .environmentObject(authViewModel)
//            }
//            .navigationTitle(course.title)
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true) // Hide the default back button
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss() // Go back
//                    }) {
//                        Image(systemName: "chevron.left") // Custom back arrow
//                            .foregroundColor(.aPrimary)
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            chefViewModel.fetchChef(chefID: course.chefID)
//        }
//        .accentColor(.aPrimary)
//    }
//}
import SwiftUI
import MapKit

struct Details: View {
    let course: Course
    @StateObject private var bookingViewModel = BookingViewModel(reachability: Reachability.init())
    @StateObject private var chefViewModel = ChefViewModel()
    @StateObject private var courseViewModel = CourseViewModel()
    @State private var region: MKCoordinateRegion
    
    @State private var showSignInSheet = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reachability: Reachability // Access Reachability

    @State private var showSuccessView = false // State to control SuccessView visibility
    @State private var navigateToProfile = false // State to control navigation to Profile
    
    @State private var showToast = false
    @State private var toastMessage = ""

    init(course: Course) {
        self.course = course
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        NavigationStack {
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

            ZStack {
                // Main Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Course Image
                        AsyncImage(url: URL(string: course.imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 240)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                            @unknown default:
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                            }
                        }
                        
                        // About the Course Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About the course:")
                                .font(.headline)
                                .bold()
                            
                            Text(course.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Course Details Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Chef:")
                                    .font(.subheadline)
                                    .bold()
                                Text(chefViewModel.chefName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Level:")
                                    .font(.subheadline)
                                    .bold()
                                Text(course.level.rawValue.capitalized)
                                    .font(.caption)
                                    .padding(.horizontal , 5)
                                    .background(Color.aPrimary.opacity(0.3))
                                    .cornerRadius(20)

                                Spacer()
                                Text("Duration:")
                                    .font(.subheadline)
                                    .bold()
                                Text(courseViewModel.calculateDurationInHours(startTime: TimeInterval(course.startDate), endTime: TimeInterval(course.endDate)))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Date & Time:")
                                    .font(.subheadline)
                                    .bold()
                                Text(courseViewModel.formattedDateAndTime(from: TimeInterval(course.startDate)))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("Location:")
                                    .font(.subheadline)
                                    .bold()
                                Text(course.locationName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Map Section
                        Map(coordinateRegion: $region)
                            .frame(height: 130)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        // Book a Space Button
                        Button(action: {
                            if authViewModel.isAuthenticated {
                                if let userID = authViewModel.currentUserID {
                                    bookingViewModel.createBooking(courseID: course.id, userID: userID)
                                    showSuccessView = true // Show SuccessView
                                } else {
                                    bookingViewModel.errorMessage = "User ID not found. Please sign in again."
                                }
                            } else {
                                showSignInSheet = true // Show the SignIn sheet
                            }
                        }) {
                            Text("Book a space")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(reachability.isConnected ? .aPrimary : .gray)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .disabled(!reachability.isConnected) // Disable button when offline

                    }
                    .padding(.vertical)
                }
                .blur(radius: showSuccessView ? 5 : 0) // Blur the background when SuccessView is visible
                .disabled(showSuccessView) // Disable interactions when SuccessView is visible

                // SuccessView
                if showSuccessView {
                    SuccessView()
                        .transition(.scale) // Add a transition
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessView = false // Hide SuccessView
                                navigateToProfile = true // Trigger navigation to Profile
                            }
                        }
                }
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
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showSignInSheet) {
                SignIn()
                    .presentationDetents([.height(650)])
                    .environmentObject(authViewModel)
            }
            .navigationTitle(course.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.aPrimary)
                    }
                }
            }
//            .background(
//                NavigationLink(destination: Profile(), isActive: $navigateToProfile) {
//                    EmptyView() // Invisible NavigationLink
//                }
//            )
        }
        .onAppear {
            chefViewModel.fetchChef(chefID: course.chefID)
        }
        .accentColor(.aPrimary)
    }
}
