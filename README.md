# MRDQRCodeReader
Custom QRCodeReader which just for scanning based on https://github.com/yannickl/QRCodeReader.swift.git


## Usage

Drop this 4 file into your project

###MRDQRCodeReader.swift
###MRDQRCodeReaderViewController.swift
###MRDQRCodeReaderOverlayView.swift
###MRDQRCodeReaderViewControllerBuilder.swift

And in which Controller You want to use

```swift
// First step 
import AVFoundation
class YourController: UIViewController,MRDQRCodeReaderViewControllerDelegate{
lazy var reader = MRDQRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
// Second step
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
// Third step
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
```
