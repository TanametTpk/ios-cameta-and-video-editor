//
//  VideoEditor.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoEditor {
    
    func merge(videos:[AVAsset], isMuted:Bool = false , callback: @escaping (URL) -> Void){
        
        let merger = VideoMerger()
        merger.isMuted = isMuted
        merger.add(assets: videos)
        merger.render(callback: callback)
        
    }
    
    func add(videos:AVAsset, isMuted:Bool = false , callback: @escaping (URL) -> Void){
        
        let merger = VideoMerger()
        merger.add(text: "Hello world")
        merger.isMuted = isMuted
        merger.add(asset: videos)
        merger.render(callback: callback)
        
    }
    
    func createVideo(images:[UIImage] , callback: @escaping (URL) -> Void){
        
        let sm = StopMotion()
        sm.render(images: images) { (url) in

            
//            callback(url)
            self.merge(videos: [AVAsset(url: url)], callback: { (output) in
                DispatchQueue.main.async {
                    callback(output)
                }
            })
            
        }
        
    }
    
    func reverse(video:AVAsset , callback: @escaping (URL) -> Void){
        
        let reverser = VideoReverser()
        reverser.reverse(video, completion: callback)
        
    }
    
    func boomerang(video:AVAsset , callback: @escaping (URL) -> Void) {
        
        reverse(video: video) { (reverseUrl) in
            
            self.merge(videos: [video , AVAsset(url: reverseUrl)], isMuted: true ,callback: { (outputUrl) in
                
                DispatchQueue.main.async {
                    callback(outputUrl)
                }
                
            })
            
        }
        
    }
    
}
