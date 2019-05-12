//
//  VideoLayer.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

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
