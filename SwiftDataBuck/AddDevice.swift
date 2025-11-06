//
//  AddTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData
import ParseSwift

struct AddDevice: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    @State private var name : String = ""
    @State private var dateAdded : Date = .now
    @State private var seleccion: String = ""
    @State private var RequireWifi : Bool = false
    
    let items = ["Amazon Echo", "Luz", "Enchufe", "TV", "Bocina", "Audifonos", "Consola de Videojuegos"]
    
    var body: some View {
        ZStack {
            Image("Fondo")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 5)
                .opacity(0.6)
            
            NavigationStack {
                VStack(spacing: 15) {
                    Form {
                        TextField("Name of the device", text: $name)
                        DatePicker("Date of purchase", selection: $dateAdded, displayedComponents: .date)
                        Picker("Dispositivo", selection: $seleccion) {
                            ForEach(items, id: \.self) { item in
                                Text(item)
                            }
                        }
                        Toggle("Require Wifi", isOn: $RequireWifi)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.ultraThinMaterial)
                    
                    .navigationTitle("Add Device")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel", systemImage: "multiply") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save", systemImage: "chevron.right") {
                                createDeviceOnBack4App()
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Crear el objeto en Back4App
    func createDeviceOnBack4App() {
        var device = ParseObject(className: "Devices")
        device["name"] = name
        device["dateAdded"] = ["__type": "Date", "iso": ISO8601DateFormatter().string(from: dateAdded)]
        device["typeOf"] = seleccion
        device["requireWifi"] = RequireWifi
        
        device.save { result in
            switch result {
            case .success(let savedDevice):
                print("✅ Device created successfully: \(savedDevice.objectId ?? "unknown")")
            case .failure(let error):
                print("❌ Error creating device:", error)
            }
        }
    }
}

#Preview {
    AddDevice()
}
