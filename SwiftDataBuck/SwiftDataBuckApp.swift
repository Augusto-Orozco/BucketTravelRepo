//
//  SwiftDataBuckApp.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataBuckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Devices.self])
    }
}
