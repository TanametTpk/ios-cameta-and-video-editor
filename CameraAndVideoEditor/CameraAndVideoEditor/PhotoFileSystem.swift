//
//  PhotoFileSystem.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 15/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import Photos
import AVKit
import AVFoundation
import UIKit

class PhotoFileSystem:FileSystem {
    
    var targetSize:CGSize!
    var result:PHFetchResult<PHAsset>?
    let requestOption = PHImageRequestOptions()
    
    init( targetSize:CGSize , ascending:Bool = false) {
        super.init([.image], ascending: ascending)
        self.targetSize = targetSize
        requestOption.isSynchronous = true
    }
    
    func setLimit(limit:Int){
        
        self.limit = limit
        
    }
    
    func get(index:Int , callback: @escaping (UIImage?, PHAuthorizationStatus) -> Void) {
        
        // if already fetch
        if let result = result {
            
            getImage(result: result, index: index, callback: callback)
            
        }
        
        // fetch image from lib
        super.get { (result, status) in
            
            guard let result = result else {
                callback( nil , status )
                return
            }
            
            DispatchQueue.main.async {
                self.getImage(result: result, index: index, callback: callback)
            }
            
        }
        
    }
    
    private func getImage( result:PHFetchResult<PHAsset> , index:Int , callback: @escaping (UIImage?, PHAuthorizationStatus) -> Void ){
        
        // number of items must always more than index
        guard result.count > index else {
            callback(nil , .authorized)
            return
        }
        
        // request image
        PHImageManager.default().requestImage(for: result.object(at: index), targetSize: self.targetSize, contentMode: .aspectFill, options: requestOption) { (image, _) in
            
            DispatchQueue.main.async {
                
                // send back image
                callback(image , .authorized)
                
            }
            
        }
        
    }
    
}
