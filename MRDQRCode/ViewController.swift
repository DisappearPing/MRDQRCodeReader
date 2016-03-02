//
//  ViewController.swift
//  MRDQRCode
//
//  Created by disappearping on 2016/1/26.
//  Copyright © 2016年 disappear. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,MRDQRCodeReaderViewControllerDelegate {

//    var captureSession: AVCaptureSession?
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var qrCodeFrameView: UIView?
    
    lazy var reader: MRDQRCodeReaderViewController = {
        let builder = MRDQRCodeReaderViewControllerBuilder { builder in
            builder.reader          = MRDQRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
            builder.showTorchButton = true
        }
        
        return MRDQRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        do{
//            let input = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession = AVCaptureSession()
//            captureSession?.addInput(input)
//        }catch {
//            print("somethingWrong")
//        }
//        
//        let captureMetadataOutput = AVCaptureMetadataOutput()
//        captureSession?.addOutput(captureMetadataOutput)
//        
//        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
//        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
//        
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//        videoPreviewLayer?.frame = view.layer.bounds
//        view.layer.addSublayer(videoPreviewLayer!)
//        
//        captureSession?.startRunning()
//        
//        qrCodeFrameView = UIView()
//        qrCodeFrameView?.layer.borderWidth = 5
//        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        
//        view.addSubview(qrCodeFrameView!)
//        view.bringSubviewToFront(qrCodeFrameView!)
    
    }

    @IBAction func scanBtnTouch(sender: UIButton) {
        if MRDQRCodeReader.supportsMetadataObjectTypes() {
            
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: MRDQRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.string) of type \(result.type)")
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
//    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        guard metadataObjects != nil && metadataObjects.count != 0 else{
//            qrCodeFrameView?.frame = CGRectZero
//            return
//        }
//        
//        let metaObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
//        if let theMetaObject = metaObject {
//            if theMetaObject.type == AVMetadataObjectTypeQRCode {
//                let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metaObject)
//                
//                qrCodeFrameView?.frame = (barCodeObject?.bounds)!
//                
//                if let theStr = theMetaObject.stringValue {
//                    print(theStr)
//                }
//            }
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - MRDQRCodeReader Delegate Methods
    
    func reader(reader: MRDQRCodeReaderViewController, didScanResult result: MRDQRCodeReaderResult) {
        self.dismissViewControllerAnimated(true, completion: { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.string, result.type),
                preferredStyle: .Alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            self?.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func readerDidCancel(reader: MRDQRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

