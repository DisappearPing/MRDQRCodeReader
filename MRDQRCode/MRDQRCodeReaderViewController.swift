//
//  MRDQRCodeViewController.swift
//  MRDQRCode
//
//  Created by disappearping on 2016/1/28.
//  Copyright © 2016年 disappear. All rights reserved.
//

import UIKit
import AVFoundation

public protocol MRDQRCodeReaderViewControllerDelegate: class {
    
    func reader(reader: MRDQRCodeReaderViewController, didScanResult result: MRDQRCodeReaderResult)
    
    func readerDidCancel(reader: MRDQRCodeReaderViewController)
}

public class MRDQRCodeReaderViewController: UIViewController {

    private var cameraView = MRDQRCodeReaderOverlayView()
    private var cancelButton = UIButton()
    
    let codeReader: MRDQRCodeReader
    let startScanningAtLoad: Bool
    
    public weak var delegate: MRDQRCodeReaderViewControllerDelegate?
    
    public var completionBlock: (MRDQRCodeReaderResult? -> Void)?
    
    deinit {
        codeReader.stopScanning()
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    convenience public init(cancelButtonTitle: String, startScanningAtLoad: Bool = true) {
        self.init(cancelButtonTitle: cancelButtonTitle, metadataObjectTypes: [AVMetadataObjectTypeQRCode], startScanningAtLoad: startScanningAtLoad)
    }

    convenience public init(metadataObjectTypes: [String], startScanningAtLoad: Bool = true) {
        self.init(cancelButtonTitle: "Cancel", metadataObjectTypes: metadataObjectTypes, startScanningAtLoad: startScanningAtLoad)
    }

    convenience public init(cancelButtonTitle: String, metadataObjectTypes: [String], startScanningAtLoad: Bool = true) {
        let reader = MRDQRCodeReader(metadataObjectTypes: metadataObjectTypes)
        
        self.init(cancelButtonTitle: cancelButtonTitle, codeReader: reader, startScanningAtLoad: startScanningAtLoad)
    }

    public convenience init(cancelButtonTitle: String, codeReader reader: MRDQRCodeReader, startScanningAtLoad startScan: Bool = true) {
        self.init(builder: MRDQRCodeReaderViewControllerBuilder { builder in
            builder.cancelButtonTitle      = cancelButtonTitle
            builder.reader                 = reader
            builder.startScanningAtLoad    = startScan
            })
    }

    required public init(builder: MRDQRCodeReaderViewControllerBuilder) {
        startScanningAtLoad    = builder.startScanningAtLoad
        codeReader             = builder.reader
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .blackColor()
        
        codeReader.didFindCodeBlock = { [weak self] resultAsObject in
            if let weakSelf = self {
                weakSelf.completionBlock?(resultAsObject)
                weakSelf.delegate?.reader(weakSelf, didScanResult: resultAsObject)
            }
        }
        
        setupUIComponentsWithCancelButtonTitle(builder.cancelButtonTitle)
        setupAutoLayoutConstraints()
        
        cameraView.layer.insertSublayer(codeReader.previewLayer, atIndex: 0)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        codeReader             = MRDQRCodeReader(metadataObjectTypes: [])
        startScanningAtLoad    = false
        
        super.init(coder: aDecoder)
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if startScanningAtLoad {
            startScanning()
        }
    }
    
    override public func viewWillDisappear(animated: Bool) {
        stopScanning()
        
        super.viewWillDisappear(animated)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        codeReader.previewLayer.frame = view.bounds
    }
    
    private func setupUIComponentsWithCancelButtonTitle(cancelButtonTitle: String) {
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cameraView)
        
        codeReader.previewLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
        cancelButton.setTitleColor(.grayColor(), forState: .Highlighted)
        cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)
    }
    
    private func setupAutoLayoutConstraints() {
        let views = ["cameraView": cameraView, "cancelButton": cancelButton]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraView][cancelButton(40)]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cameraView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cancelButton]-|", options: [], metrics: nil, views: views))
        
    }

    // MARK: - Controlling the Reader
    
    /// Starts scanning the codes.
    public func startScanning() {
        codeReader.startScanning()
    }
    
    /// Stops scanning the codes.
    public func stopScanning() {
        codeReader.stopScanning()
    }
    
    // MARK: - Catching Button Events
    
    func cancelAction(button: UIButton) {
        codeReader.stopScanning()
        
        if let _completionBlock = completionBlock {
            _completionBlock(nil)
        }
        
        delegate?.readerDidCancel(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
