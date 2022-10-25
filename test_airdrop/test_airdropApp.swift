//
//  test_airdropApp.swift
//  test_airdrop
//
//  Created by 米田 悠人  on 2022/10/21.
//
//

import SwiftUI

@main
struct test_airdropApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
