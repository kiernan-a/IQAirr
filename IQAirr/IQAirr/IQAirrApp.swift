//
//  IQAirrApp.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.
//

import SwiftUI

@main
struct IQAirrApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
