//
//  VideoCamera.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoCamera:Camera{
    
    var audioDevice: AVCaptureDeviceInput?
    var videoOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
    var delegate: AVCaptureFileOutputRecordingDelegate!
    
    init(delegate:AVCaptureFileOutputRecordingDelegate) {
        
        super.init()
        
        self.delegate = delegate
        
        if let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio){
            
            do{
                let audioDevice = try AVCaptureDeviceInput(device: audioDevice)
                self.audioDevice = audioDevice
                addInput(input: audioDevice)
            }catch{
                print(error)
            }
            
        }

        addOutput(output: videoOutput)
        
    }
    
    public func startRecord(tmpFile:String = "tmp.mov"){
        
        let url = FileManager.default.getTempFileUrl(path: tmpFile)
        videoOutput.startRecording(to: url, recordingDelegate: delegate)
        
    }
    
    public func stopRecord(){
        videoOutput.stopRecording()
    }
    
}
