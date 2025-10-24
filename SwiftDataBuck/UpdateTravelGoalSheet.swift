//
//  UpdateTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 23/10/25.
//

import SwiftUI
import SwiftData

struct UpdateTravelGoalSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var context
    @Bindable var travelGoal : TravelGoal
    
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Destination", text: $travelGoal.name)
                DatePicker("Date", selection: $travelGoal.dateAdded, displayedComponents: .date)
                Toggle("Visited", isOn: $travelGoal.visited)
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
