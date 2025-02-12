//
//  BookedCourseDetails.swift
//  Bakery
//
//  Created by Maryam Bahwal on 28/07/1446 AH.
//


import SwiftUI
import MapKit

struct BookedCourseDetails: View {
    let bookingID : String
    let course: Course
    @StateObject private var bookingViewModel = BookingViewModel(reachability: Reachability.init()) // Use @StateObject correctly
    @StateObject private var chefViewModel = ChefViewModel()
    @StateObject private var courseViewModel = CourseViewModel()
    @State private var region: MKCoordinateRegion
    
    @State private var showSignInSheet = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reachability: Reachability // Access Reachability

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var showCancelAlert = false // State to control the alert

    init(course: Course , bookingID: String) {
        self.bookingID = bookingID
        self.course = course
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: course.locationLatitude, longitude: course.locationLongitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
                // Cancel Booking Button
                                    Button(action: {
                                        showCancelAlert = true // Show the alert
                                    }) {
                                        Text("Cancel booking")
                                            .foregroundColor(reachability.isConnected ? .red : .gray)
                                            .padding()
                                    }
                                    .padding(.vertical)
                                    .disabled(!reachability.isConnected)
//                NavigationLink(destination: Profile()){
//                    Text("Cancel booking")
//                        .foregroundColor(.red)
//                        .padding()
//                        .onTapGesture {
//                            bookingViewModel.cancelBooking(bookingID: bookingID)
//                        }
//                }
                .padding(.vertical)
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(course.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back
                    }) {
                        Image(systemName: "chevron.left") // Custom back arrow
                            .foregroundColor(.aPrimary)
                    }
                }
            }
        }
        .alert(isPresented: $showCancelAlert) {
                        Alert(
                            title: Text("Cancel Booking"),
                            message: Text("Do you want to cancel your booking?"),
                            primaryButton: .default(Text("Yes").foregroundColor(.aPrimary)) {
                                bookingViewModel.cancelBooking(bookingID: bookingID)
                                presentationMode.wrappedValue.dismiss() // Navigate back to Profile
                            },
                            secondaryButton: .cancel(Text("No").foregroundColor(.aPrimary))
                        )
                    }
                
        .navigationBarBackButtonHidden(true)
        .onAppear {
            
            chefViewModel.fetchChef(chefID: course.chefID)
        }
//        .accentColor(.aPrimary)
    }
}


//#Preview {
//    BookedCourseDetails()
//}
