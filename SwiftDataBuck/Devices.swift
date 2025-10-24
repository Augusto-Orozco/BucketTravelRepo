//
//  TravelGoal.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import Foundation
import SwiftData

@Model
class Devices {
    var name : String
    var dateAdded : Date
    var typeOf : String
    var requireWifi : Bool
    
    init(name: String, dateAdded: Date, typeOf: String, requireWifi: Bool) {
        self.name = name
        self.dateAdded = dateAdded
        self.typeOf = typeOf
        self.requireWifi = requireWifi
    }
    
    static func isValidName(_ name: String ) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
