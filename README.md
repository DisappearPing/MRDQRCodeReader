# MRDQRCodeReader
Custom QRCodeReader which just for scanning based on https://github.com/yannickl/QRCodeReader.swift.git


## Usage

Drop this 4 file into your project

MRDQRCodeReader.swift
MRDQRCodeReaderViewController.swift
MRDQRCodeReaderOverlayView.swift
MRDQRCodeReaderViewControllerBuilder.swift

And in which Controller You want to use

```swift
// First step 
lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
// Second step
 @IBAction func startScan(sender: UIButton) {
        guard QRCodeReader.isAvailable() != false else{
            print("not available")
            
            return
        }
        
        reader.delegate = self
        reader.modalPresentationStyle = .FormSheet
        presentViewController(reader, animated: true) { () -> Void in
            
        }
    }
// Third step
// MARK: QRCodeReaderViewControllerDelegate
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        let theResultString = result.value
        let theResultType = result.metadataType
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            let alert = UIAlertController(title: "掃描結果", message: "\(theResultString))", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "前往", style: UIAlertActionStyle.Destructive, handler: { (alert) -> Void in
                guard UIApplication.sharedApplication().canOpenURL(NSURL(string:theResultString)!) != false else {
                    
                   
                    
                    return
                }
                
                UIApplication.sharedApplication().openURL(NSURL(string:theResultString)!)
            })
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
                
            })
            
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

```
