//
//  PictureCamera.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class PictureCamera:Camera{
    
    var stillImageOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    var delegate:AVCapturePhotoCaptureDelegate!
    
    init(delegate:AVCapturePhotoCaptureDelegate) {
        
        super.init()
        
        self.delegate = delegate
        addOutput(output: stillImageOutput)
        
    }
    
    public func capture(){
        
        let setting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: setting, delegate: delegate)
        
    }
    
}
