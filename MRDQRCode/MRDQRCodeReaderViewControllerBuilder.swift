//
//  MRDQRCodeReaderViewControllerBuilder.swift
//  MRDQRCode
//
//  Created by disappearping on 2016/1/28.
//  Copyright © 2016年 disappear. All rights reserved.
//

import Foundation

public final class MRDQRCodeReaderViewControllerBuilder {
    
    public typealias MRDQRCodeReaderViewControllerBuilderBlock = (builder: MRDQRCodeReaderViewControllerBuilder) -> Void
    
    public var cancelButtonTitle: String = "Cancel"
    
    public var reader: MRDQRCodeReader = MRDQRCodeReader()
    
    public var startScanningAtLoad: Bool = true
    
    public var showSwitchCameraButton: Bool = true
    
    public var showTorchButton: Bool = false
    
    public init() {}
    
    public init(@noescape buildBlock: MRDQRCodeReaderViewControllerBuilderBlock) {
        buildBlock(builder: self)
    }

}