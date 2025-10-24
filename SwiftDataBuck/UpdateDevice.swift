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
    
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Name of the device", text:$devicePurchased.name)
                DatePicker("Date of purchase", selection: $devicePurchased.dateAdded, displayedComponents: .date)
                TextField("Type of device", text: $devicePurchased.typeOf)
                Toggle("Require Wifi", isOn: $devicePurchased.requireWifi)
            }
            .navigationTitle("Update Travel Goal")
            .navigationBarTitleDisplayMode( .large)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Done"){
                        try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}
