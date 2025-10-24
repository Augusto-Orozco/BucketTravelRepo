//
//  ContentView.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingItemSheet = false
    @State private var selectedDevice: Devices? = nil
    @Query(sort: \Devices.dateAdded) var devices : [Devices]
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(devices){ devices in
                        Button {
                            selectedDevice = devices
                        } label: {
                            Text(devices.name)
                        }
                        .buttonStyle(.plain)
                    }
                .onDelete { offsets in
                    offsets.map { devices[$0] }.forEach(context.delete)
                    try? context.save()
                }

                }
                .navigationTitle("Dispositivos")
                .navigationBarTitleDisplayMode( .large)
                .sheet(isPresented: $isShowingItemSheet){
                    AddDevice()
                }
                
                .sheet(item: $selectedDevice) { device in
                    UpdateDevice(devicePurchased: device)
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
        .modelContainer(for: [Devices.self], inMemory: true)
}
