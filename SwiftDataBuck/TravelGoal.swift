//
//  TravelGoal.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import Foundation
import SwiftData

@Model
class TravelGoal {
    var name : String
    var dateAdded : Date
    var visited : Bool
    
    init(name: String, dateAdded: Date, visited: Bool) {
        self.name = name
        self.dateAdded = dateAdded
        self.visited = visited
    }
    
    static func isValidName(_ name: String ) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
