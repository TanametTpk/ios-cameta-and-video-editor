//
//  VideoTransform.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

class VideoTransform{
    
    static func orientationFromTransform(_ transform: CGAffineTransform)
        -> (orientation: UIImage.Orientation, isPortrait: Bool) {
            
            var assetOrientation = UIImage.Orientation.up
            var isPortrait = false
            if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
                assetOrientation = .right
                isPortrait = true
            } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
                assetOrientation = .left
                isPortrait = true
            } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
                assetOrientation = .up
            } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
                assetOrientation = .down
            }
            return (assetOrientation, isPortrait)
            
    }
    
    static func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset)
        -> AVMutableVideoCompositionLayerInstruction {
            
            let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
            let assetTrack = asset.tracks(withMediaType: .video)[0]
            
            let transform = assetTrack.preferredTransform
            let assetInfo = orientationFromTransform(transform)
            
            var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
            
            if assetInfo.isPortrait {
                
                scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
                let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
                instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: CMTime.zero)
                
            } else {
                print("test")
//                let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
//                var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
//                if assetInfo.orientation == .down {
//
//                    let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                    let windowBounds = UIScreen.main.bounds
//                    let yFix = assetTrack.naturalSize.height + windowBounds.height
//                    let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
//                    concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
//
//                }
//                instruction.setTransform(concat, at: CMTime.zero)
                
            }
            
            return instruction
    }
    
}
