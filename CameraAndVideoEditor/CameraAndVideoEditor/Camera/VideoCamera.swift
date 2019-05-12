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
    
    var tmpFile:String = "tmp.mov"
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
    
    public func startRecord(){
        
        let url = getUrl()
        videoOutput.startRecording(to: url, recordingDelegate: delegate)
        
    }
    
    public func stopRecord(){
        videoOutput.stopRecording()
    }
    
    private func getUrl() -> URL{
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent(tmpFile)
        
        try? FileManager.default.removeItem(at: fileUrl)
        
        return fileUrl
        
    }
    
}
