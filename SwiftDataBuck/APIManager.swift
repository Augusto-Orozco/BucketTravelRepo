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
        return response.results
    }
    
    // MARK: - POST (Create)
    func addDevice(_ device: Devices) async throws {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let body: [String: Any] = [
            "name": device.name,
            "dateAdded": ISO8601DateFormatter().string(from: device.dateAdded),
            "typeOf": device.typeOf,
            "requireWifi": device.requireWifi
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        _ = try await URLSession.shared.data(for: request)
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

struct ParseResponse: Codable {
    let results: [Devices]
}
