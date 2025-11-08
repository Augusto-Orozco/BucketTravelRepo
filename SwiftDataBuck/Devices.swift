//
//  TravelGoal.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import Foundation
import ParseSwift

struct Devices: ParseObject, Identifiable {
    var originalData: Data?
    
    // MARK: - Requerido por ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?

    // MARK: - Campos personalizados
    var name: String?
    var dateAdded: Date?
    var typeOf: String?
    var requireWifi: Bool?

    // MARK: - Nombre de la clase en Back4App
    static var className = "Devices"

    // MARK: - Inicializadores
    init() { }
    
    init(name: String, dateAdded: Date, typeOf: String, requireWifi: Bool) {
        self.name = name
        self.dateAdded = dateAdded
        self.typeOf = typeOf
        self.requireWifi = requireWifi
    }

    // MARK: - Lógica de íconos
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

    // MARK: - Validación de nombre
    static func isValidName(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
