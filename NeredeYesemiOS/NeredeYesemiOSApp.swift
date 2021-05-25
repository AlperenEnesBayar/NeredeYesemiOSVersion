//
//  NeredeYesemiOSApp.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI
import LocalAuthentication

@main
struct NeredeYesemiOSApp: App {
    @State private var isUnlock = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if(isUnlock)
                {
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
            .onAppear(perform: authenticate)
        }
    }
    
    func authenticate() {
        let contex = LAContext()
        var error: NSError?
        
        if contex.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "We need to unlock your device."
            contex.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success{
                        self.isUnlock = true
                    }
                    else{
                        exit(0)
                    }
                }
                
            }
        }
        else
        {
            self.isUnlock = true
        }
    }
}
