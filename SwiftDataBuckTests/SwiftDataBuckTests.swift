//
//  SwiftDataBuckTests.swift
//  SwiftDataBuckTests
//
//  Created by Alumno on 23/10/25.
//

import Testing
@testable import SwiftDataBuck
internal import Foundation

struct SwiftDataBuckTests {

    @Test("Name must no be empy or whitespace")
    func testNameValidation() async throws {
        #expect(Devices.isValidName("Cupertino"))
        #expect(!Devices.isValidName(""))
        #expect(!Devices.isValidName(" "))
        
    }
    
    @Test("Device update must correctly modify all properties and validate name")
    func testDeviceUpdate() async throws {
        let device = Devices(name: "MacBook Pro", dateAdded: .now, typeOf: "Laptop", requireWifi: true)
        
        device.name = "iMac"
        device.typeOf = "Desktop"
        device.requireWifi = false
        let newDate = Date(timeIntervalSinceNow: -86400)
        device.dateAdded = newDate
        
        #expect(device.name == "iMac")
        #expect(device.typeOf == "Desktop")
        #expect(device.requireWifi == false)
        #expect(device.dateAdded == newDate)
        
        #expect(Devices.isValidName(device.name))
        #expect(!Devices.isValidName(""))
        #expect(!Devices.isValidName(" "))
    }


}
