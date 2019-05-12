//
//  VideoPlayerDelegate.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

protocol VideoPlayerDelegate {
    
    func videoDidEnd()
    
    func observerProgess(seconds:Double , durationSeconds:Double , progess:Double)
    
}
