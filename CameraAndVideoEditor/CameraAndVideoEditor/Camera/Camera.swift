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
    
    var cameraPreviewLater: AVCaptureVideoPreviewLayer?
    
    init() {
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
            
            cameraPreviewLater = AVCaptureVideoPreviewLayer(session:captureSession)
            cameraPreviewLater?.videoGravity = .resizeAspectFill
            
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
        
        view.layer.addSublayer(cameraPreviewLater!)
        cameraPreviewLater?.frame = view.layer.frame
        
    }
    
    public func start(){
        captureSession.startRunning()
    }
    
    public func stop(){
        captureSession.stopRunning()
    }
    
}
