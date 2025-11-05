import Foundation

struct APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://parseapi.back4app.com/classes/Devices"
    private let appId = "ztw3VfOgUbk3OyFrUBDtX2V708Mz5ajMHUW0lQEu"
    private let apiKey = "LJQqLP1HlqbeqWn8Tb751aCdh7eWuZb66gMjNLOp"
    
    private var headers: [String: String] {
        [
            "X-Parse-Application-Id": appId,
            "X-Parse-REST-API-Key": apiKey,
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - GET (Read)
    func fetchDevices() async throws -> [Devices] {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ParseResponse.self, from: data)
        
        // Map BackendDevice -> Devices (tu modelo @Model)
        let isoFormatter = ISO8601DateFormatter()
        return response.results.map { backend in
            // Convertir la fecha Parse a Date
            let date: Date
            if let iso = backend.dateAdded?.iso, let d = isoFormatter.date(from: iso) {
                date = d
            } else {
                date = .now
            }
            let dev = Devices(name: backend.name,
                              dateAdded: date,
                              typeOf: backend.typeOf,
                              requireWifi: backend.requireWifi)
            dev.objectId = backend.objectId
            return dev
        }
    }
    
    // MARK: - POST (Create)
    func addDevice(_ device: Devices) async throws {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        // Back4App espera el campo date como { "__type":"Date", "iso": "..." }
        let iso = ISO8601DateFormatter().string(from: device.dateAdded)
        let body: [String: Any] = [
            "name": device.name,
            "dateAdded": ["__type": "Date", "iso": iso],
            "typeOf": device.typeOf,
            "requireWifi": device.requireWifi
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        // Opcional: puedes parsear la respuesta para obtener objectId y asignarlo a device
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let objectId = json["objectId"] as? String {
            device.objectId = objectId
        }
    }
    
    // MARK: - PUT (Update)
    func updateDevice(_ device: Devices, objectId: String) async throws {
        let url = URL(string: "\(baseURL)/\(objectId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let body: [String: Any] = [
            "name": device.name,
            "typeOf": device.typeOf,
            "requireWifi": device.requireWifi
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - DELETE
    func deleteDevice(objectId: String) async throws {
        let url = URL(string: "\(baseURL)/\(objectId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        _ = try await URLSession.shared.data(for: request)
    }
}

// -----------------------------
// DTOs para parsear la respuesta
// -----------------------------

// ParseResponse: lo que devuelve GET /classes/Devices
struct ParseResponse: Codable {
    let results: [BackendDevice]
}

// BackendDevice: corresponde a cada item en "results"
// Nota: dateAdded en Parse viene como objeto: { "__type": "Date", "iso": "2025-..." }
struct BackendDevice: Codable {
    let objectId: String?
    let name: String
    let dateAdded: ParseDate?
    let typeOf: String
    let requireWifi: Bool
}

struct ParseDate: Codable {
    let __type: String
    let iso: String
}
