//
//  FOOTApp.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import SwiftUI

@main
struct FOOTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
