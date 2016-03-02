//
//  MRDQRCode.swift
//  MRDQRCode
//
//  Created by disappearping on 2016/1/26.
//  Copyright © 2016年 disappear. All rights reserved.
//

import UIKit
import AVFoundation

public struct MRDQRCodeReaderResult {
    public let string: String
    public let type: String
}

public class MRDQRCodeReader: NSObject,AVCaptureMetadataOutputObjectsDelegate {
    var defaultDevice: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    lazy var defaultDeviceInput: AVCaptureDeviceInput? = {
        return try? AVCaptureDeviceInput(device: self.defaultDevice)
    }()
    
    var metadataOutput = AVCaptureMetadataOutput()
    var session = AVCaptureSession()
    
    public lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        return AVCaptureVideoPreviewLayer(session: self.session)
    }()
    
    public let metadataObjectTypes: [String]
    
    public var stopScanningWhenCodeIsFound: Bool = true
    
    public var didFindCodeBlock: (MRDQRCodeReaderResult -> Void)?
    
    public var running: Bool {
        get {
            return session.running
        }
    }
    
    public convenience override init() {
        self.init(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    }
    
    public init(metadataObjectTypes types: [String]) {
        metadataObjectTypes = types
        
        super.init()
        
        configureDefaultComponents()
    }
    
    private func configureDefaultComponents() {
        session.addOutput(metadataOutput)
        
        if let _defaultDeviceInput = defaultDeviceInput {
            session.addInput(_defaultDeviceInput)
        }
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        metadataOutput.metadataObjectTypes = metadataObjectTypes
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }

    func startScanning() {
        if !session.running {
            session.startRunning()
        }
    }
    
    public func stopScanning() {
        if session.running {
            session.stopRunning()
        }
    }
    
    public class func isAvailable() -> Bool {
        if AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count == 0 {
            return false
        }
        
        do {
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let _             = try AVCaptureDeviceInput(device: captureDevice)
            
            return true
        } catch _ {
            return false
        }
    }

    public class func supportsMetadataObjectTypes(metadataTypes: [String]? = nil) -> Bool {
        if !isAvailable() {
            return false
        }
        
        // Setup components
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let deviceInput   = try! AVCaptureDeviceInput(device: captureDevice)
        let output        = AVCaptureMetadataOutput()
        let session       = AVCaptureSession()
        
        session.addInput(deviceInput)
        session.addOutput(output)
        
        var metadataObjectTypes = metadataTypes
        
        if metadataObjectTypes == nil || metadataObjectTypes?.count == 0 {
            // Check the QRCode metadata object type by default
            metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        
        for metadataObjectType in metadataObjectTypes! {
            if !output.availableMetadataObjectTypes.contains({ $0 as! String == metadataObjectType }) {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - AVCaptureMetadataOutputObjects Delegate Methods
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for current in metadataObjects {
            if let _readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
                if metadataObjectTypes.contains(_readableCodeObject.type) {
                    if stopScanningWhenCodeIsFound {
                        stopScanning()
                    }
                    
                    let scannedResult = MRDQRCodeReaderResult(string: _readableCodeObject.stringValue, type:_readableCodeObject.type)
                    
                    dispatch_async(dispatch_get_main_queue(), { [weak self] in
                        self?.didFindCodeBlock?(scannedResult)
                        })
                }
            }
        }
    }

}