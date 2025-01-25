//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Rohan Patel on 1/21/25.
//

import AVFoundation
import UIKit

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didFail(with error: CameraError)
}

enum CameraError: String{
    case invalidDevice  
    case invalidScannedValue
}

final class ScannerVC: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerVCDelegate: ScannerVCDelegate?
    
    init(scannerVCDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerVCDelegate = scannerVCDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else {
            scannerVCDelegate?.didFail(with: .invalidDevice)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else{
            scannerVCDelegate?.didFail(with: .invalidDevice)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            scannerVCDelegate?.didFail(with: .invalidDevice)
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .upce]
        }
        else{
            scannerVCDelegate?.didFail(with: .invalidDevice)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metaDataObject = metadataObjects.first else{
            scannerVCDelegate?.didFail(with: .invalidScannedValue)
            return
        }
        
        guard let machineReadableCodeObject = metaDataObject as? AVMetadataMachineReadableCodeObject else {
            scannerVCDelegate?.didFail(with: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableCodeObject.stringValue else {
            scannerVCDelegate?.didFail(with: .invalidScannedValue)
            return
        }
        captureSession.stopRunning()
        scannerVCDelegate?.didFind(barcode: barcode)
    }
}
