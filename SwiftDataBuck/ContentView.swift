//
//  ContentView.swift
//  SwiftDataBuck
//
//  Created by Alumno on 20/10/25.
//

import SwiftUI
import ParseSwift

struct ContentView: View {
    @State private var isShowingItemSheet = false
    @State private var selectedDevice: Devices? = nil
    @State private var devices: [Devices] = []
    
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
                    ForEach(devices, id: \.objectId) { device in
                        Button {
                            selectedDevice = device
                        } label: {
                            HStack {
                                Image(systemName: device.iconForDevice(device.typeOf ?? ""))
                                    .foregroundColor(.primary)
                                
                                Text(device.name ?? "Unnamed")
                                    .font(.headline)
                                
                                Spacer()
                                
                                if device.requireWifi ?? false {
                                    Image(systemName: "wifi")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteDevice)
                }
                .scrollContentBackground(.hidden)
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Devices")
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .sheet(isPresented: $isShowingItemSheet) {
                AddDevice(onRefresh: {
                    await queryDevicesFromBack4App()
                })
                    .presentationDetents([.medium])
            }
            .sheet(item: $selectedDevice) { device in
                UpdateDevice(onRefresh: {
                    await queryDevicesFromBack4App()
                }, devicePurchased: device)
                    .presentationDetents([.medium])
            }
            .task {
                await queryDevicesFromBack4App()
            }
        }
    }
    
    // MARK: - Leer (Read)
    func queryDevicesFromBack4App() async {
        do {
            let foundDevices = try await Devices.query().find()
            devices = foundDevices
        } catch {
            print("Error fetching devices:", error.localizedDescription)
        }
    }
    
    // MARK: - Eliminar (Delete)
    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            let device = devices[index]
            Task {
                do {
                    try await device.delete()
                    devices.remove(at: index)
                } catch {
                    print("Error deleting:", error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
