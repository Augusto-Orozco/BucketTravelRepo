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
    @State private var TypeOf : String = ""
    @State private var RequireWifi : Bool = false
    
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Name of the device", text:$name)
                DatePicker("Date of purchase", selection: $dateAdded, displayedComponents: .date)
                TextField("Type of device", text: $TypeOf)
                Toggle("Require Wifi", isOn: $RequireWifi)
            }
            .navigationTitle("Add Device")
            .navigationBarTitleDisplayMode( .large)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Save"){
                        let devicePurchased = Devices(name: name, dateAdded: dateAdded, typeOf: TypeOf, requireWifi: RequireWifi)
                        
                        context
                            .insert(devicePurchased)
                        
                        try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddDevice()
}
