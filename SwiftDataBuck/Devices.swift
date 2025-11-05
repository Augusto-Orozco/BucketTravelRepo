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
    var objectId: String? 
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
    
    func iconForDevice(_ type: String) -> String {
        switch type.lowercased() {
        case let t where t.contains("echo"):
            return "dot.radiowaves.left.and.right"
        case let t where t.contains("luz"):
            return "lightbulb"
        case let t where t.contains("enchufe"):
            return "powerplug"
        case let t where t.contains("tv"):
            return "tv"
        case let t where t.contains("bocina"):
            return "speaker.wave.2"
        case let t where t.contains("audifono"):
            return "headphones"
        case let t where t.contains("consola"):
            return "gamecontroller"
        default:
            return "wifi.circle"
        }
    }

    
    static func isValidName(_ name: String ) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
