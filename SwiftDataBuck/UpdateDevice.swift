//
//  UpdateTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
import SwiftData
import ParseSwift

struct UpdateDevice: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @Bindable var devicePurchased : Devices
    
    let items = ["Amazon Echo", "Luz", "Enchufe", "TV", "Bocina", "Audifonos", "Consola de Videojuegos"]
    
    var body: some View {
        ZStack {
            Image("Fondo2")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 5)
                .opacity(0.6)
            
            NavigationStack {
                VStack(spacing: 15) {
                    Form {
                        TextField("Name of the device", text: $devicePurchased.name)
                        DatePicker("Date of purchase", selection: $devicePurchased.dateAdded, displayedComponents: .date)
                        Picker("Dispositivo", selection: $devicePurchased.typeOf) {
                            ForEach(items, id: \.self) { items in
                                Text(items)
                            }
                        }
                        Toggle("Require Wifi", isOn: $devicePurchased.requireWifi)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.ultraThinMaterial)
                    
                    .navigationTitle("Update Device")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel", systemImage: "multiply") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done", systemImage: "chevron.right") {
                                updateDeviceOnBack4App()
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actualizar objeto en Back4App con ParseSwift
    func updateDeviceOnBack4App() {
        guard let objectId = devicePurchased.objectId else {
            print("⚠️ No objectId found for this device.")
            return
        }
        
        let query = ParseQuery(className: "Devices").where("objectId" == objectId)
        
        query.first { result in
            switch result {
            case .success(var device):
                // ✅ Actualizar los campos
                device["name"] = devicePurchased.name
                device["typeOf"] = devicePurchased.typeOf
                device["requireWifi"] = devicePurchased.requireWifi
                device["dateAdded"] = [
                    "__type": "Date",
                    "iso": ISO8601DateFormatter().string(from: devicePurchased.dateAdded)
                ]
                
                // ✅ Guardar cambios en Back4App
                device.save { saveResult in
                    switch saveResult {
                    case .success:
                        print("✅ Device updated successfully.")
                    case .failure(let error):
                        print("❌ Error saving device:", error)
                    }
                }
                
            case .failure(let error):
                print("❌ Error fetching device:", error)
            }
        }
    }
}

#Preview {
    UpdateDevice(devicePurchased: Devices(
        name: "TV Samsung",
        dateAdded: .now,
        typeOf: "TV",
        requireWifi: true
    ))
}
