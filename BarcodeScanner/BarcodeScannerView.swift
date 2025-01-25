//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 1/20/25.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext{
    static let invalidDeviceInput = AlertItem(title: "Device not supported",
                                              message: "Could not find a valid video capture device.",
                                              dismissButton: .default(Text("OK")))
    
    static let invalidScannedItem = AlertItem(title: "Invalid scanned item",
                                              message: "Scanned value is invalid. Scanner only supports UPC and barcode.",
                                              dismissButton: .default(Text("OK")))
}

struct BarcodeScannerView: View {
    
    @State private var scannedCode = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedBarcode: $scannedCode, alertItem: $alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 50)
                
                Label("Scan Barcode", systemImage: "barcode.viewfinder")
                    .font(.title3)
                
                Text(scannedCode.isEmpty ? "Barcode Not Scanned" : scannedCode)
                    .foregroundStyle(scannedCode.isEmpty ? .red : .green)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $alertItem) { alertItem in
                Alert(title: Text(alertItem.title),
                      message: Text(alertItem.message),
                      dismissButton: alertItem.dismissButton)
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
