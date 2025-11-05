//
//  SwiftDataBuckApp.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData
import ParseSwift

@main
struct SwiftDataBuckApp: App {
    
    init() {
            ParseSwift.initialize(
                applicationId: "ztw3VfOgUbk3OyFrUBDtX2V708Mz5ajMHUW0lQEu",
                clientKey: "CLIENT_KEY",
                serverURL: URL(string: "https://parseapi.back4app.com")!
            )
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Devices.self])
    }
}
