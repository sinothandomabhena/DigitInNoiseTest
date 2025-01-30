//
//  DiNTApp.swift
//  DiNT
//
//  Created by Sinothando on 2025/01/30.
//

import SwiftUI

@main
struct DiNTApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
