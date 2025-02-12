//
//  SuccessView.swift
//  Bakery
//
//  Created by Maryam Bahwal on 28/07/1446 AH.
//

import SwiftUI
struct SuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.aPrimary)
            
            Text("Successful")
                .font(.title)
                .bold()
                .padding(.top, 8)
                .foregroundColor(.aPrimary)
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it takes full space
//        .background(Color.black.opacity(0.4)) // Semi-transparent background
//        .edgesIgnoringSafeArea(.all) // Cover the entire screen
        
//        .offset(x: 500 , y: 200)
        .frame(width: 156, height: 158, alignment: .center)
        .padding()
        .background(.aBackground)
        .cornerRadius(12)
//        .padding(.bottom, 500)
        
    }
}
#Preview{
    SuccessView()
}
