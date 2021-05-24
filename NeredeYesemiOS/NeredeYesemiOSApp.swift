//
//  NeredeYesemiOSApp.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI

@main
struct NeredeYesemiOSApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView{
                NavigationView{
                    SearchRestaurantView()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search Restaurant")
                }
                
                NavigationView{
                    ProfileView()
                }
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
            }
            
            
        }
    }
}
