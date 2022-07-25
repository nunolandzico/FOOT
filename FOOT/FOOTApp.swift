//
//  FOOTApp.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import SwiftUI
import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

@main
struct FOOTApp: App {
    let persistenceController = PersistenceController.shared
    
    init(){
        AppCenter.start(withAppSecret: "fcae9e37-05e8-494f-a3b2-b380a2b4f5df",services: [Analytics.self, Crashes.self])
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
