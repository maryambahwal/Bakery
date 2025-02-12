//
//  Courses.swift
//  Bakery
//
//  Created by Maryam Bahwal on 19/07/1446 AH.
//

import SwiftUI

struct Courses: View {
    @StateObject private var courseViewModel = CourseViewModel()
    @State private var searchText = ""

    @EnvironmentObject var reachability: Reachability
    @State private var showToast = false
    @State private var toastMessage = ""
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView
            VStack(spacing: 0) {
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
                Text("Courses")
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
            }
            .onChange(of: searchText) { newValue in
                courseViewModel.filterCourses(by: newValue)
            }
        }
        
    

    }
}

#Preview {
    Courses()
}
