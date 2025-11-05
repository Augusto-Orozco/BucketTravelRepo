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
                    gradient: Gradient(colors: [.gray.opacity(0.1), .black.opacity(0.4)]),
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
                        offsets.map { devices[$0] }.forEach { device in
                            context.delete(device)
                            if let id = device.objectId {
                                Task {
                                    try? await APIManager.shared.deleteDevice(objectId: id)
                                }
                            }
                        }
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
            .task {
                do {
                    let remoteDevices = try await APIManager.shared.fetchDevices()
                    for dev in remoteDevices {
                        context.insert(dev)
                    }
                } catch {
                    print("Error al obtener datos: \(error)")
                }
            }


        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Devices.self], inMemory: true)
}
