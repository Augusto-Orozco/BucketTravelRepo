//
//  UpdateTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
import SwiftData

struct UpdateDevice: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var context
    @Bindable var devicePurchased : Devices
    
    let items = ["Amazon Echo", "Luz", "Enchufe", "TV", "Bocina", "Audifonos", "Consola de Videojuegos"]
    
    var body: some View {
        ZStack{
            Image("Fondo2")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 5)
                .opacity(0.6)
            
            NavigationStack {
                VStack(spacing: 15){
                    Form{
                        TextField("Name of the device", text:$devicePurchased.name)
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
                    .navigationBarTitleDisplayMode( .large)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel", systemImage: "multiply"){
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button("Done", systemImage: "chevron.right"){
                                try! context.save()
                                Task {
                                    if let id = devicePurchased.objectId {
                                        try? await APIManager.shared.updateDevice(devicePurchased, objectId: id)
                                    }
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
