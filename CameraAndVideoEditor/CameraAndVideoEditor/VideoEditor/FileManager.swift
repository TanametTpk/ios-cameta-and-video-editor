//
//  FileManager.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import Foundation

extension FileManager {
    
    func getTempFileUrl(path:String) -> URL{
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent(path)
        
        try? FileManager.default.removeItem(at: fileUrl)
        
        return fileUrl
        
    }
    
}
