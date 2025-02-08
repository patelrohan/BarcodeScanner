//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 1/20/25.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    @StateObject var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedBarcode: $viewModel.scannedCode,
                            alertItem: $viewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 50)
                
                Label("Scan Barcode", systemImage: "barcode.viewfinder")
                    .font(.title3)
                
                Text(viewModel.statusText)
                    .foregroundStyle(viewModel.statusTextColor)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem) { alertItem in
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
