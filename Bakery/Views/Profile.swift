//
//  Profile.swift
//  Bakery
//
//  Created by Maryam Bahwal on 19/07/1446 AH.
//
import SwiftUI
struct Profile: View {
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var userViewModel = UserViewModel(reachability: Reachability.init())
    @StateObject private var bookingViewModel = BookingViewModel(reachability: Reachability.init())
    @StateObject private var courseViewModel = CourseViewModel()
    @State private var isEditing = false
    @State private var editedName = ""
    
    @State private var showToast = false
    @State private var toastMessage = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
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
                Text("Profile")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Divider
                Divider()
                    .padding(.vertical, 10)
                
                // User Profile Section
                UserProfileSection(
                    userViewModel: userViewModel,
                    isEditing: $isEditing,
                    editedName: $editedName
                )
                
                // Divider
                Divider()
                    .padding(.vertical, 10)
                
                // Booked Courses Section
                BookedCoursesSection(
                    bookingViewModel: bookingViewModel,
                    courseViewModel: courseViewModel
                )
                
                Spacer()
            }
            .onAppear {
                            courseViewModel.fetchCourses()
                            if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                                bookingViewModel.fetchBookings(for: userID)
                            }
                        }
            .background(Color(UIColor.systemGray6))
            .onAppear {
                if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                    userViewModel.fetchUser(userID: userID)
                    bookingViewModel.fetchBookings(for: userID)
                    courseViewModel.fetchCourses()
                }
            }
        }
        .onAppear {
                        bookingViewModel.fetchBookings(for: authViewModel.currentUserID ?? "")
                    }
    }
    
}
struct UserProfileSection: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var reachability: Reachability // Access Reachability
    @ObservedObject var userViewModel: UserViewModel
    @Binding var isEditing: Bool
    @Binding var editedName: String

    @State private var showToast = false
    @State private var toastMessage = ""
    var body: some View {
        VStack(alignment: .leading) {

            if authViewModel.isAuthenticated {
                if let user = userViewModel.user {
                    HStack {
                        Spacer()
                        HStack {
                            Image("ProfileView")
                                .resizable()
                                .frame(width: 46, height: 46)
                                .scaledToFit()
                                .padding(12)
                                .padding(.leading, 3)
                            
                            if isEditing {
                                TextField("Name", text: $editedName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 150)
                            } else {
                                Text(user.name ?? "username")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if isEditing {
                                    // Save the updated name
                                    userViewModel.updateUser(name: editedName)
                                } else {
                                    // Enter edit mode
                                    editedName = userViewModel.user?.name ?? ""
                                }
                                isEditing.toggle()
                            }) {
                                Text(isEditing ? "Done" : "Edit")
                                    .font(.subheadline)
                                    .foregroundColor(.aPrimary)
                                    .padding(.trailing)
                                    .bold(true)
                            }
                            .disabled(!reachability.isConnected)
                        }
                        .frame(width: 379, height: 78)
                        .background(Color(.white))
                        .cornerRadius(7)
                        Spacer()
                    }
                } else if userViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text("No user data found.")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } else {
                // Display dummy data when the user is not signed in
                HStack {
                    Spacer()
                    HStack {
                        Image("ProfileView")
                            .resizable()
                            .frame(width: 46, height: 46)
                            .scaledToFit()
                            .padding(12)
                            .padding(.leading, 3)
                        
                        Text("username")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            // No action for edit button when not signed in
                        }) {
                            Text("Edit")
                                .font(.subheadline)
                                .foregroundColor(.aPrimary)
                                .padding(.trailing)
                                .bold(true)
                        }
                        .disabled(true)
                    }
                    .frame(width: 379, height: 78)
                    .background(Color(.white))
                    .cornerRadius(7)
                    Spacer()
                }
            }
        }
        .onAppear {
            userViewModel.fetchUser(userID: authViewModel.currentUserID ?? "")
                        if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                            userViewModel.fetchUser(userID: authViewModel.currentUserID ?? "")
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
    }
    
}

struct BookedCourseRow: View {
    let course: Course
    let bookingID: String

    var body: some View {
        NavigationLink(destination: BookedCourseDetails(course: course , bookingID: bookingID)) {
            CourseRow(course: course)
        }
    }
}
struct BookedCoursesSection: View {
    @ObservedObject var bookingViewModel: BookingViewModel
    @ObservedObject var courseViewModel: CourseViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Booked courses")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.bottom , 15)
                .padding(.horizontal , 0)
            ScrollView {
                VStack(spacing: 12) {
                    if bookingViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if bookingViewModel.bookings.isEmpty {
                        Image("unSignIn")
                            .resizable()
                            .frame(width: 171.63, height: 43)
                        Text("No booked courses found.")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(bookingViewModel.bookings, id: \.id) { booking in
                            if let course = courseViewModel.courses.first(where: { $0.id == booking.fields.courseID }) {
                                BookedCourseRow(course: course, bookingID: booking.id)
                            }
                        }
                    }
                }
                
            }
        }
        .onAppear {
                        courseViewModel.fetchCourses()
                        if authViewModel.isAuthenticated, let userID = authViewModel.currentUserID {
                            bookingViewModel.fetchBookings(for: userID)
                        }
                    }
        .padding()
        .foregroundColor(.black)
    }
        
}
