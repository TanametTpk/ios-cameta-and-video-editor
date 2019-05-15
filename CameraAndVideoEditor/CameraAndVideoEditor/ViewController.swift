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
import Photos

class ViewController: UIViewController {
    
    let MAX_TIME:Double = 15
    let controller = VideoPlayer()
    var camera:VideoCamera!
    var urls:[URL] = [URL]()
    var savedImage:[UIImage] = [UIImage]()
    
    var imageButton:UIImageView = {
        
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
        
    }()

    var recordButton:VideoCaptureButton = {
       
        let size = UIScreen.main.bounds.size.width / 5
        let view = VideoCaptureButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    var swap:UIButton = {
        
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("swap", for: .normal)
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        controller.delegate = self
        
        camera = VideoCamera(delegate: self)
        camera.timerDelegate = self
        camera.setPreviewLayer(view: view)
        camera.start()
        
        view.addSubview(swap)
        
        view.addSubview(recordButton)
        let y = view.bounds.height - recordButton.bounds.height
        recordButton.center = CGPoint(x: view.center.x, y: y)
        recordButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(capture)))
        
        swap.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        swap.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        swap.addTarget(self, action: #selector(swapCamera), for: .touchUpInside)
        
        view.addSubview(imageButton)
        imageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -20).isActive = true
        imageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageButton.widthAnchor.constraint(equalTo: imageButton.heightAnchor).isActive = true
        
        test()
        
    }
    
    func test(){
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            if status == .authorized {
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
                
                fetchOptions.fetchLimit = 1
                
                let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                
                if fetchResult.count > 0 {
                              
                    DispatchQueue.main.async {
                        self.getImage(index: 0, result: fetchResult)
                    }
                    
                }
                
                
            }
            
        }
        
    }
    
    func getImage(index:Int , result:PHFetchResult<PHAsset>){
        
        let requestOption = PHImageRequestOptions()
        requestOption.isSynchronous = true
        
        PHImageManager.default().requestImage(for: result.object(at: index), targetSize: view.frame.size, contentMode: .aspectFill, options: requestOption) { (image, _) in
            
            DispatchQueue.main.async {
                // image here
                self.imageButton.image = image
            }
            
        }
        
    }
    
    @objc
    private func capture(){
//        camera.capture()
        if !self.camera.videoOutput.isRecording{
            recordButton.startRecord()
            camera.startRecord(tmpFile: "tmp-\(self.urls.count).mov")
        }else{
            recordButton.stopRecord()
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

extension ViewController: TimerObservable{
    
    func observeTime(second: Double) {
        
        if second >= MAX_TIME {
            
            // stop
            capture()
            
        }
        
    }
    
}
