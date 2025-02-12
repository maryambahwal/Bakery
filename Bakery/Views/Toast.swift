//
//  Toast.swift
//  Bakery
//
//  Created by Maryam Bahwal on 07/08/1446 AH.
//

import SwiftUI

struct Toast: View {
    var message: String

    var body: some View {
        if(message == "You are offline"){
            HStack {
                Image(systemName: "wifi.slash")
                Text(message)
            }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                    .animation(.easeInOut, value: message)
            
        }
        else{
            HStack {
                Image(systemName: "wifi")
                Text(message)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .transition(.opacity)
            .animation(.easeInOut, value: message)
        }
        
    }
}
//
//#Preview {
//    Toast()
//}
