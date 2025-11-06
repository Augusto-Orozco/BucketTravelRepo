//
//  AddTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import ParseSwift

struct AddDevice: View {
    
    var onRefresh: (() async -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var dateAdded: Date = .now
    @State private var seleccion: String = ""
    @State private var requireWifi: Bool = false
    
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
                        Toggle("Require Wifi", isOn: $requireWifi)
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
                                Task {
                                    await createDeviceOnBack4App()
                                    
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
    
    // MARK: - Crear el objeto en Back4App usando ParseSwift
    func createDeviceOnBack4App() async {
        let device = Devices(
            name: name,
            dateAdded: dateAdded,
            typeOf: seleccion,
            requireWifi: requireWifi
        )

        do {
            try await device.save()
        } catch {
            print("Error creating device:", error.localizedDescription)
        }
    }
}

#Preview {
    AddDevice()
}
