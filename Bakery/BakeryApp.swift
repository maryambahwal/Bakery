//
//  BakeryApp.swift
//  Bakery
//
//  Created by Maryam Bahwal on 17/07/1446 AH.
//

import SwiftUI
import Network

@main
struct BakeryApp: App {
    @StateObject private var authViewModel = AuthViewModel(reachability: Reachability())
    @StateObject private var reachability = Reachability()
    init() {
            // Configure URLCache with a memory and disk capacity
            let cacheSizeMemory = 100 * 1024 * 1024 // 100 MB memory
            let cacheSizeDisk = 200 * 1024 * 1024 // 200 MB disk
            URLCache.shared = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "bakeryCache")
        }
//    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            Splash()
                .environmentObject(authViewModel)
                .environmentObject(reachability) // Pass Reachability to views

            
        }
    }
}
