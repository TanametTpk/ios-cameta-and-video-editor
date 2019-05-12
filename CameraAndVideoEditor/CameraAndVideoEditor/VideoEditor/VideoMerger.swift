//
//  VideoMerger.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoMerger {
    
    var mixComposition = AVMutableComposition()
    var tracks:[AVMutableCompositionTrack] = [AVMutableCompositionTrack]()
    var instructions:[AVMutableVideoCompositionLayerInstruction] = [AVMutableVideoCompositionLayerInstruction]()
    var totalTime:CMTime = CMTime.zero
    let tmpFileName:String = "mergeTmp.mov"
    var isMuted:Bool = false
    
    var parentLayer:CALayer!
    var videoLayer:CALayer!
    var size:CGSize!
    
    init() {
        
        size = UIScreen.main.bounds.size
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer = videolayer
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        
        parentLayer = parentlayer
        
    }
    
    func render( callback: @escaping (URL)->Void ){
        
        let size = UIScreen.main.bounds
        let url = FileManager.default.getTempFileUrl(path: tmpFileName)
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {return}
        
        let mainInstruction = AVMutableVideoCompositionInstruction()

        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration:totalTime)

        mainInstruction.layerInstructions = instructions
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: size.width, height: size.height)
        mainComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        exporter.exportAsynchronously {
            
            DispatchQueue.main.async {
                // finish export
                callback(url)
            }
            
        }
        
    }
    
    func add(asset:AVAsset){
        
        guard let track = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {return}
        
        do{
            
            try track.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: asset.tracks(withMediaType: .video)[0], at: totalTime)
            
            if let audioTrack = asset.tracks(withMediaType: .audio).first , !isMuted{
                
                createTrackSound(asset: asset, assetTrack: audioTrack)
                
            }

            totalTime = CMTimeAdd(totalTime, asset.duration)
            
            let instruction = VideoTransform.videoCompositionInstruction(track, asset: asset)
            instruction.setOpacity(0, at: totalTime)
            
            tracks.append(track)
            instructions.append(instruction)
            
        }catch{
            print(error)
        }
        
    }
    
    func createTrackSound(asset:AVAsset , assetTrack:AVAssetTrack){
        
        guard let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {return}
        
        do{
            
            try audioTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: assetTrack, at: totalTime)
            
        }catch{
            print(error)
        }
        
    }
    
    func add(assets:[AVAsset]){
        
        for a in assets{
            add(asset: a)
        }
        
    }
    
    func add(text:String){
        
        let titleLayer = CATextLayer()
        titleLayer.string = text
        titleLayer.font = UIFont(name: "Helvetica", size: 28)
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = CATextLayerAlignmentMode.center
        titleLayer.frame = CGRect(x: 0, y: 50, width: size.width, height: size.height / 6)
        
        parentLayer.addSublayer(titleLayer)
        
    }
    
}
