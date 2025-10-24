//
//  AddTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData

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
            
            NavigationStack{
                VStack(spacing: 15){
                    Form {
                        TextField("Name of the device", text:$name)
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
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel", systemImage: "multiply") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button("Save", systemImage: "chevron.right") {
                                let devicePurchased = Devices(
                                    name: name,
                                    dateAdded: dateAdded,
                                    typeOf: seleccion,
                                    requireWifi: RequireWifi
                                )
                                context.insert(devicePurchased)
                                try! context.save()
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    AddDevice()
}
