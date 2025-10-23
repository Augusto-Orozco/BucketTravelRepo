//
//  SwiftDataBuckTests.swift
//  SwiftDataBuckTests
//
//  Created by Alumno on 23/10/25.
//

import Testing
@testable import SwiftDataBuck

struct SwiftDataBuckTests {

    @Test("Name must no be empy or whitespace")
    func testNameValidation() async throws {
        #expect(TravelGoal.isValidName("Cupertino"))
        #expect(!TravelGoal.isValidName(""))
        #expect(!TravelGoal.isValidName(" "))
        
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
