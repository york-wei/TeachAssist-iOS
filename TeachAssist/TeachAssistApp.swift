//
//  TeachAssistApp.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import SwiftUI

@main
struct TeachAssistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
