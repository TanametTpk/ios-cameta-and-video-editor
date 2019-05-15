//
//  FileSystem.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 15/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation
import Photos
import AVKit
import AVFoundation

class FileSystem {
    
    var limit:Int = Int.max
    var types:[PHAssetMediaType]!
    var ascending:Bool!
    
    init(_ type: [PHAssetMediaType] , ascending:Bool = false) {
        
        // if empty array
        if type.count < 1 {
            self.types = [PHAssetMediaType.image]
        }else{
            self.types = type
        }
        
        self.ascending = ascending
        
    }
    
    public func get(callback: @escaping ( PHFetchResult<PHAsset>? , PHAuthorizationStatus ) -> Void){
        
        // request for access data
        PHPhotoLibrary.requestAuthorization { (status) in
            
            if status == .authorized {
                
                // sort fetch
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: self.ascending) ]
                
                // create predicate
                fetchOptions.predicate = self.createPredicate()
                
                // set limit
                fetchOptions.fetchLimit = self.limit
                
                // fetch data
                let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
                
                // check have item
                if fetchResult.count > 0 {
                    
                    DispatchQueue.main.async {
                        
                        callback(fetchResult , status)
                        
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        
                        callback(nil , status)
                        
                    }
                    
                }
                
                
            }else{
                
                DispatchQueue.main.async {
                    
                    callback(nil , status)
                    
                }
                
            }
        }
    }
    
    private func createPredicate() -> NSPredicate{
        
        var format:String = ""
        var argumetArray:[Int] = [Int]()
        
        for i in 0...types.count-1 {
            
            let preString = " || "
            
            format +=  ( i == 0 ? "" : preString ) + "mediaType == %d"
            argumetArray.append(types[i].rawValue)
            
        }
        
        return NSPredicate(format: format, argumentArray: argumetArray)
        
    }
    
}
