//
//  ViewController.swift
//  CameraAndVideoEditor
//
//  Created by Tanamet Tanasinpatcharakul on 12/5/2562 BE.
//  Copyright © 2562 Tanamet Tanasinpatcharakul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var player = VideoPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.delegate = self
        player.setVideoLayer(url: URL(string: "http://192.168.1.105:7000/videos/9000.mp4")!)
        present(player, animated: true, completion: nil)
        
    }

    func setup(){
        
    }
    
}

extension ViewController: VideoPlayerDelegate{
    
    func videoDidEnd(){
        
        player.replay()
        
    }
    
    func observerProgess(seconds:Double , durationSeconds:Double , progess:Double){
        
    }
    
}
