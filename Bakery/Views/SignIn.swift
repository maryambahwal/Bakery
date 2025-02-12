////
////  SignIn.swift
////  Bakery
////
////  Created by Maryam Bahwal on 25/07/1446 AH.
////
//import SwiftUI
//
//struct SignIn: View {
//    @Environment(\.presentationMode) var presentationMode
//    @StateObject private var userViewModel = UserViewModel()
//    @State private var email = ""
//    @State private var password = ""
//    @State private var errorMessage: String?
//    var onSignInSuccess: (() -> Void)?
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Sign In")
//                .font(.largeTitle)
//                .bold()
//            
//            TextField("Email", text: $email)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .autocapitalization(.none)
//                .padding()
//            
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .font(.caption)
//            }
//            
//            Button(action: {
//                userViewModel.signIn(email: email, password: password) { result in
//                    switch result {
//                    case .success:
//                        onSignInSuccess?()
//                        presentationMode.wrappedValue.dismiss()
//                    case .failure(let error):
//                        errorMessage = error.localizedDescription
//                    }
//                }
//            }) {
//                Text("Sign In")
//                    .bold()
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    SignIn()
//}






//new code
//
//import SwiftUI
//struct SignIn: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @Binding var isPresented: Bool
//    @State private var username = ""
//    @State private var password = ""
//
//    var body: some View {
//        VStack {
//            Text("Sign In")
//                .font(.largeTitle)
//                .padding()
//            
//            TextField("Username", text: $username)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("Sign In") {
//                authViewModel.signIn(username: username, password: password)
//                if authViewModel.isAuthenticated {
//                    isPresented = false // Dismiss the modal
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            .padding()
//        }
//    }
//}
//#Preview {
//    @State var isPresented = true // Temporary state for preview
//    return SignIn(isPresented: $isPresented)
//        .environmentObject(AuthViewModel()) // Provide the environment object
//}
//
//import SwiftUI
//
//struct SignIn: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @State private var username = ""
//    @State private var password = ""
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Sign In")
//                    .font(.largeTitle)
//                    .padding()
//                
//                TextField("Username", text: $username)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                if let errorMessage = authViewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                        .padding()
//                }
//                
//                Button("Sign In") {
//                    authViewModel.signIn(username: username, password: password)
//                }
//                .buttonStyle(.borderedProminent)
//                .padding()
//                
//                NavigationLink(
//                    destination: Profile(),
//                    isActive: $authViewModel.isAuthenticated,
//                    label: { EmptyView() }
//                )
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    SignIn()
//        .environmentObject(AuthViewModel())
//}
//
//import SwiftUI
//
//struct SignIn: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @State private var username = ""
//    @State private var password = ""
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Sign In")
//                    .font(.largeTitle)
//                    .padding()
//                
//                TextField("Username", text: $username)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                if let errorMessage = authViewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .font(.caption)
//                        .padding()
//                }
//                
//                Button("Sign In") {
//                    authViewModel.signIn(username: username, password: password)
//                }
//                .buttonStyle(.borderedProminent)
//                .padding()
//
//                // Navigate to the Profile view when authenticated
//                NavigationLink(
//                    destination: Profile(),
//                    isActive: $authViewModel.isAuthenticated,
//                    label: { EmptyView() }
//                )
//            }
//            .padding()
//        }
//    }
//}
//#Preview {
//    SignIn()
//        .environmentObject(AuthViewModel())
//}
import SwiftUI

struct SignIn: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss // Add this to dismiss the sheet
    @State private var email = "" // Change "username" to "email"
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                Text("Sign in")
                    .font(.largeTitle)
//                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.aBrown).bold()
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal)
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.aBrown).bold()
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Error Message
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding()
                }
                
                // Sign In Button
                Button(action: {
                    authViewModel.signIn(username: email, password: password)
                }) {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.aPrimary) // Use Pink color
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
                if isAuthenticated {
                    dismiss() // Dismiss the sheet when authenticated
                }
            }
        }
    }
}
//
//#Preview {
//    SignIn()
//        .environmentObject(AuthViewModel())
//}
