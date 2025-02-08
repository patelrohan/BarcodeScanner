//
//  BSAlert.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 2/8/25.
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
