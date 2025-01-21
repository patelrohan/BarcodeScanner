//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 1/20/25.
//

import SwiftUI

struct BarcodeScannerView: View {
    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 50)
                
                Label("Scan Barcode", systemImage: "barcode.viewfinder")
                    .font(.title3)
                
                Text("Barcode Not Scanned")
                    .foregroundStyle(.red)
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScannerView()
}
