//
//  ContentView.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData
import ParseSwift

struct ContentView: View {
    @State private var isShowingItemSheet = false
    @State private var selectedDevice: Devices? = nil
    @Query(sort: \Devices.dateAdded) var devices: [Devices]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.gray.opacity(0.1), .black.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                List {
                    ForEach(devices) { device in
                        Button {
                            selectedDevice = device
                        } label: {
                            HStack {
                                Image(systemName: device.iconForDevice(device.typeOf))
                                    .foregroundColor(.primary)
                                
                                Text(device.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                if device.requireWifi {
                                    Image(systemName: "wifi")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        // Al eliminar, borrar tanto local como en Back4App
                        offsets.map { devices[$0] }.forEach { device in
                            // 1️⃣ Borra localmente
                            context.delete(device)
                            
                            // 2️⃣ Borra en Back4App usando ParseSwift
                            if let id = device.objectId {
                                deleteDeviceOnBack4App(objectId: id)
                            }
                        }
                        try? context.save()
                    }
                }
                .scrollContentBackground(.hidden)
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Devices")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                }
            }
            
            .sheet(isPresented: $isShowingItemSheet) {
                AddDevice()
                    .presentationDetents([.medium])
            }
            .sheet(item: $selectedDevice) { device in
                UpdateDevice(devicePurchased: device)
                    .presentationDetents([.medium])
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
                    isShowingItemSheet = true
                }
            }
            
            // 🔄 Cargar datos desde Back4App al iniciar
            .task {
                queryDevicesFromBack4App()
            }
        }
    }
    
    // MARK: - Leer objetos (Read)
    func queryDevicesFromBack4App() {
        let query = ParseQuery(className: "Devices")
        query.find { result in
            switch result {
            case .success(let foundDevices):
                print("✅ Found \(foundDevices.count) devices in Back4App.")
                
                for deviceObj in foundDevices {
                    let name = deviceObj["name"] as? String ?? "Unnamed"
                    let typeOf = deviceObj["typeOf"] as? String ?? ""
                    let requireWifi = deviceObj["requireWifi"] as? Bool ?? false
                    var dateAdded = Date()
                    
                    // Manejar fecha si viene en formato Parse
                    if let dateDict = deviceObj["dateAdded"] as? [String: String],
                       let iso = dateDict["iso"],
                       let parsed = ISO8601DateFormatter().date(from: iso) {
                        dateAdded = parsed
                    }
                    
                    // Crear objeto local SwiftData
                    let dev = Devices(
                        name: name,
                        dateAdded: dateAdded,
                        typeOf: typeOf,
                        requireWifi: requireWifi
                    )
                    dev.objectId = deviceObj.objectId
                    
                    context.insert(dev)
                }
                try? context.save()
                
            case .failure(let error):
                print("❌ Error fetching devices:", error)
            }
        }
    }
    
    // MARK: - Eliminar objeto (Delete)
    func deleteDeviceOnBack4App(objectId: String) {
        let query = ParseQuery(className: "Devices").where("objectId" == objectId)
        
        query.first { result in
            switch result {
            case .success(let device):
                device.delete { deleteResult in
                    switch deleteResult {
                    case .success:
                        print("🗑️ Deleted device \(objectId) successfully.")
                    case .failure(let error):
                        print("❌ Error deleting device:", error)
                    }
                }
            case .failure(let error):
                print("❌ Error finding device to delete:", error)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Devices.self], inMemory: true)
}
