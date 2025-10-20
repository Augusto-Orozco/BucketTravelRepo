//
//  AddTravelGoalSheet.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData

struct AddTravelGoalSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var context
    @State private var name : String = ""
    @State private var dateAdded : Date = .now
    @State private var visited : Bool = false
    
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Destination", text:$name)
                DatePicker("Date", selection: $dateAdded, displayedComponents: .date)
                Toggle("Visited", isOn: $visited)
            }
            .navigationTitle("Add Travel Goal")
            .navigationBarTitleDisplayMode( .large)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button("Save"){
                        let travelGoal = TravelGoal(name: name, dateAdded: dateAdded, visited: visited)
                        
                        context
                            .insert(travelGoal)
                        
                        try! context.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddTravelGoalSheet()
}
