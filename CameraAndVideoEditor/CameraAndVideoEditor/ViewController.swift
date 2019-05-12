//
//  ViewController.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    let controller = VideoPlayer()
    var camera:VideoCamera!
    var urls:[URL] = [URL]()
    var savedImage:[UIImage] = [UIImage]()
    
    var record:UIButton = {
       
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.setTitle("record", for: .normal)
        return view
        
    }()
    
    var swap:UIButton = {
        
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.setTitle("swap", for: .normal)
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        controller.delegate = self
        
        camera = VideoCamera(delegate: self)
        camera.setPreviewLayer(view: view)
        camera.start()
        
        view.addSubview(record)
        view.addSubview(swap)
        record.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        record.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        record.addTarget(self, action: #selector(capture), for: .touchUpInside)
        
        swap.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        swap.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swap.addTarget(self, action: #selector(swapCamera), for: .touchUpInside)
        
    }
    
    @objc
    private func capture(){
//        camera.capture()
        if !self.camera.videoOutput.isRecording{
            record.setTitle("Stop", for: .normal)
            camera.startRecord(tmpFile: "tmp-\(self.urls.count).mov")
        }else{
            record.setTitle("Record", for: .normal)
            camera.stopRecord()
        }
        
    }
    
    @objc
    private func swapCamera(){
        
        camera.swapCamera()
        
    }
    
}

extension ViewController : AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageData = photo.fileDataRepresentation(){
            
//            UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            
            savedImage.append(UIImage(data: imageData)!)
            
            if savedImage.count > 2{
                
                let editor = VideoEditor()
                editor.createVideo(images: savedImage) { (url) in

                    DispatchQueue.main.async {
                        self.controller.setVideoLayer(url: url)
                        self.present(self.controller, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension ViewController : AVCaptureFileOutputRecordingDelegate{
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {

//        self.urls.append(outputFileURL)
        let editor = VideoEditor()
        editor.add(videos: AVAsset(url: outputFileURL)) { (url) in
            DispatchQueue.main.async {
                self.controller.setVideoLayer(url: url)
                self.present(self.controller, animated: true, completion: nil)
            }
        }
        
    }
    
}

extension ViewController: VideoPlayerDelegate {
    
    func observerProgess(seconds: Double, durationSeconds: Double, progess: Double) {
        return
    }
    
    func videoDidEnd() {
        controller.replay()
    }
    
}
