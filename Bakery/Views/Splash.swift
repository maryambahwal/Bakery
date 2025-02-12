//
//  Splash.swift
//  Bakery
//
//  Created by Maryam Bahwal on 17/07/1446 AH.
//

import SwiftUI

struct Splash: View {
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            if navigateToHome {
                MainView() // Navigate to the Home view after 3 seconds
            } else {
                VStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 202.61, height: 168.46)
                    
                    Text("Home Bakery")
                        .foregroundColor(.aBrown)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    
                    Text("Baked to Perfection")
                        .foregroundColor(.aBrown)
                        .font(.system(size: 26, weight: .medium, design: .rounded))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.aBackground)
                .onAppear {
                    // Delay for 3 seconds before navigating
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        navigateToHome = true
                    }
                }
            }
        }
    }
}

#Preview {
    Splash()
}
