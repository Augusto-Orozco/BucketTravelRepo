//
//  UpdateTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
import ParseSwift

struct UpdateDevice: View {
    
    var onRefresh: (() async -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @State var devicePurchased: Devices
    
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
                        TextField("Name of the device", text: Binding(
                            get: { devicePurchased.name ?? "" },
                            set: { devicePurchased.name = $0 }
                        ))
                        
                        DatePicker(
                            "Date of purchase",
                            selection: Binding(
                                get: { devicePurchased.dateAdded ?? .now },
                                set: { devicePurchased.dateAdded = $0 }
                            ),
                            displayedComponents: .date
                        )
                        
                        Picker("Dispositivo", selection: Binding(
                            get: { devicePurchased.typeOf ?? "" },
                            set: { devicePurchased.typeOf = $0 }
                        )) {
                            ForEach(items, id: \.self) { item in
                                Text(item)
                            }
                        }
                        
                        Toggle(
                            "Require Wifi",
                            isOn: Binding(
                                get: { devicePurchased.requireWifi ?? false },
                                set: { devicePurchased.requireWifi = $0 }
                            )
                        )
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
                                Task {
                                    await updateDeviceOnBack4App()
                                    if let refresh = onRefresh {
                                        await refresh()
                                    }
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actualizar en Back4App
    func updateDeviceOnBack4App() async {
        do {
            try await devicePurchased.save()
        } catch {
            print("Error updating device:", error.localizedDescription)
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
