//
//  ContentView.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //var travelgoals : [TravelGoal] = []
    @State private var isShowingItemSheet = false
    @State private var selectedTravelGoal: TravelGoal? = nil
    @Query(sort: \TravelGoal.dateAdded) var travelgoals : [TravelGoal]
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(travelgoals){ travelgoal in
                        Button {
                            selectedTravelGoal = travelgoal
                        } label: {
                            Text(travelgoal.name)
                        }
                        .buttonStyle(.plain)
                    }
                .onDelete { offsets in
                    offsets.map { travelgoals[$0] }.forEach(context.delete)
                    try? context.save()
                }

                }
                .navigationTitle("Travel Goals")
                .navigationBarTitleDisplayMode( .large)
                .sheet(isPresented: $isShowingItemSheet){
                    AddTravelGoalSheet()
                }
                
                .sheet(item: $selectedTravelGoal) { travelgoal in
                    UpdateTravelGoalSheet(travelGoal: travelgoal)
                }
                .toolbar{
                    Button("Add", systemImage: "plus"){
                        isShowingItemSheet = true
                    }
                }
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TravelGoal.self], inMemory: true)
}
