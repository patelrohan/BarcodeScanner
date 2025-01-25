//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 1/24/25.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {

    @Binding var scannedBarcode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerVCDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedBarcode = barcode
        }
        
        func didFail(with error: CameraError) {
            switch error{
                case .invalidDevice:
                    scannerView.alertItem = AlertContext.invalidDeviceInput
                case .invalidScannedValue:
                    scannerView.alertItem = AlertContext.invalidScannedItem
                
            }
        }
    }
}
