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
    @Query(sort: \TravelGoal.dateAdded) var travelgoals : [TravelGoal]
    
    
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(travelgoals){ travelgoal in
                    Text(travelgoal.name)
                }
            }
            .navigationTitle("Travel Goals")
            .navigationBarTitleDisplayMode( .large)
            .sheet(isPresented: $isShowingItemSheet){
                AddTravelGoalSheet()
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
