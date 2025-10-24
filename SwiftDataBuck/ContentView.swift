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
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.gray.opacity(0.5), .white.opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                List {
                    ForEach(devices) { devices in
                        Button {
                            selectedDevice = devices
                        } label: {
                            HStack {
                                
                                Image(systemName: devices.iconForDevice(devices.typeOf))
                                    .foregroundColor(.primary)
                                
                                Text(devices.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                if devices.requireWifi {
                                    Image(systemName: "wifi")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        offsets.map { devices[$0] }.forEach(context.delete)
                        try? context.save()
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Devices")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.leading)
                }
            }
            //.navigationTitle("Dispositivos Wifi")
            //.navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddDevice()
                    .presentationDetents([.medium])
            }
            .sheet(item: $selectedDevice) { device in
                UpdateDevice(devicePurchased: device)
                    .presentationDetents([.medium])
            }
            .toolbar {
                Button("Add", systemImage: "plus") {
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
