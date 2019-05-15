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
    var timerDelegate: TimerObservable?
    
    var timer:Timer?
    var second:Double = 0
    var timeInterval:Double = 0.1
    
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
        startTimer()
        
    }
    
    public func stopRecord(){
        stopTimer()
        videoOutput.stopRecording()
    }
    
    private func startTimer(){
        
        // if already have timer stop it
        if self.timer != nil {
            stopTimer()
        }
        
        // set time to 0
        second = 0
        
        // init timer
        self.timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(tiktok), userInfo: nil, repeats: true)
        
        RunLoop.current.add(self.timer!, forMode: .common)
        
    }
    
    private func stopTimer(){
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    
    @objc
    private func tiktok(){
        
        second += timeInterval
        self.timerDelegate?.observeTime(second: second)
        
    }
    
}
