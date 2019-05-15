//
//  Camera.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class Camera{
    
    var captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let minimumZoom: CGFloat = 1.0
    var maximumZoom: CGFloat = 5.0
    var lastZoomFactor: CGFloat = 1.0
    
    var videoView:UIView?
    
    init(maximumZoom:CGFloat = 5.0) {
        
        self.maximumZoom = maximumZoom
        
        setupInput()
        setupSystem()
    }
    
    private func setupInput(){
        
        frontFacingCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        backFacingCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        currentDevice = backFacingCamera
        
    }
    
    func addInput(input:AVCaptureInput){
        
        if captureSession.canAddInput(input){
            captureSession.addInput(input)
        }
        
    }
    
    func addOutput(output:AVCaptureOutput){
        
        if captureSession.canAddOutput(output){
            captureSession.addOutput(output)
        }
        
    }
    
    func addInput(inputs: [AVCaptureInput]){
        
        for i in inputs{
            addInput(input: i)
        }
        
    }
    
    func addOutput(outputs:[AVCaptureOutput]){
        
        for o in outputs{
            addOutput(output: o)
        }
        
    }
    
    private func setupSystem(){
        
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session:captureSession)
            cameraPreviewLayer?.videoGravity = .resizeAspectFill
            
        }catch {
            print(error)
        }
        
    }
    
    public func swapCamera(){
        
        let newDevice = (currentDevice?.position == .back) ? frontFacingCamera : backFacingCamera
        
        for input in captureSession.inputs{
            
            captureSession.removeInput(input as! AVCaptureDeviceInput)
            
        }
        
        let cameraInput: AVCaptureDeviceInput
        do{
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        }catch{
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput){
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
        
    }
    
    public func setPreviewLayer(view:UIView){
        
        view.layer.addSublayer(cameraPreviewLayer!)
        
        videoView = view
        cameraPreviewLayer?.frame = view.layer.frame
        
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touch)))
        
    }
    
    public func start(){
        captureSession.startRunning()
    }
    
    public func stop(){
        captureSession.stopRunning()
    }
    
    @objc
    func pinch(_ pinch: UIPinchGestureRecognizer) {

        guard let device = currentDevice else { return }

        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }

        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }

        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)

        switch pinch.state {
            case .began: fallthrough
            case .changed: update(scale: newScaleFactor)
            case .ended:
                lastZoomFactor = minMaxZoom(newScaleFactor)
                update(scale: lastZoomFactor)
            default: break
        }
        
    }
    
    @objc
    func touch(_ touch: UITapGestureRecognizer) {

        let screenSize = videoView!.bounds.size
        
        let x = touch.location(in: videoView).y / screenSize.height
        let y = 1.0 - touch.location(in: videoView).x / screenSize.width
        let focusPoint = CGPoint(x: x, y: y)
        
        if let device = currentDevice {
            
            do {
                try device.lockForConfiguration()
                
                device.focusPointOfInterest = focusPoint
                //device.focusMode = .continuousAutoFocus
                device.focusMode = .autoFocus
                //device.focusMode = .locked
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                device.unlockForConfiguration()
            }
            catch {
                // just ignore
            }
            
        }
        
    }
    
    public func turnOnFlash(){
        
        guard let avDevice = currentDevice else{return}
        
        // check if the device has torch
        if avDevice.hasTorch {
            
            // lock your device for configuration
            do {
                try avDevice.lockForConfiguration()
            } catch {

            }
            
            // check if your torchMode is on or off. If on turns it off otherwise turns it on
            if !avDevice.isTorchActive {
                
                do {
                    
                    try avDevice.setTorchModeOn(level: 1.0)
                    
                } catch {
                    
                }
                
            }
            // unlock your device
            avDevice.unlockForConfiguration()
        }
        
    }
    
    public func turnOffFlash(){
        
        guard let avDevice = currentDevice else{return}
        
        // check if the device has torch
        if avDevice.hasTorch {
            
            // lock your device for configuration
            do {
                try avDevice.lockForConfiguration()
            } catch {

            }
            
            // check if your torchMode is on or off. If on turns it off otherwise turns it on
            if avDevice.isTorchActive {
                
                avDevice.torchMode = AVCaptureDevice.TorchMode.off
                
            }
            
            // unlock your device
            avDevice.unlockForConfiguration()
        }
        
    }
    
}
