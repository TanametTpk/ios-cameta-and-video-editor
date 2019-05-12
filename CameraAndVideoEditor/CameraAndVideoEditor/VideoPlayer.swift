//
//  VideoPlayer.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoPlayer:UIViewController {
    
    var videoLayer:VideoLayer = {
        
        let view = VideoLayer()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var delegate:VideoPlayerDelegate?
    var isMuted:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        
        view.addSubview(videoLayer)
        videoLayer.frame = view.frame
        videoLayer.playerLayer.videoGravity = .resizeAspectFill
        
        videoLayer.playerLayer.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main, using: { (progressTime) in
            
            if let duration = self.videoLayer.playerLayer.player?.currentItem?.duration{
                
                let durationSec = CMTimeGetSeconds(duration)
                let sec = CMTimeGetSeconds(progressTime)
                let progess = Double(sec / durationSec)
                
                DispatchQueue.main.async {
                    
                    self.delegate?.observerProgess(seconds: sec, durationSeconds: durationSec, progess: progess)
                    
                    if progess >= 1.0 {
                        
                        self.delegate?.videoDidEnd()
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    public func setVideoLayer(url:URL){
        
        videoLayer.playerLayer.player = AVPlayer(url: url)
        
    }
    
    public func play(){
        
        videoLayer.playerLayer.player?.play()
        
    }
    
    public func pause(){
        
        videoLayer.playerLayer.player?.pause()
        
    }
    
    public func toggleMute(){
        
        self.isMuted = !self.isMuted
        videoLayer.playerLayer.player?.isMuted = self.isMuted
        
    }
    
    public func fastForward(by seconds: Float64){
        
        if let currentTime = videoLayer.playerLayer.player?.currentTime(), let duration = videoLayer.playerLayer.player?.currentItem?.duration {
            
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            let durationSec = CMTimeGetSeconds(duration)
            
            if newTime >= durationSec{
                newTime = durationSec
            }
            
            skipVideo(time: newTime)
            
        }
        
    }
    
    public func rewind(by seconds: Float64){
        
        if let currentTime = videoLayer.playerLayer.player?.currentTime(){
            
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            
            skipVideo(time: newTime)
            
        }
        
    }
    
    private func skipVideo(time:Double){
        
        videoLayer.playerLayer.player?.seek(to: CMTime(value: CMTimeValue(time * 1000), timescale: 1000))
        
    }
    
    public func reset(){
        
        videoLayer.playerLayer.player?.seek(to: CMTime.zero)
        
    }
    
    public func replay(){
        
        reset()
        play()
        
    }
    
}

class VideoLayer:UIView {
    
    override static var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
    
    var playerLayer:AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    var player:AVPlayer? {
        
        get{
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
        
    }
    
}

protocol VideoPlayerDelegate {
    
    func videoDidEnd()
    
    func observerProgess(seconds:Double , durationSeconds:Double , progess:Double)
    
}
